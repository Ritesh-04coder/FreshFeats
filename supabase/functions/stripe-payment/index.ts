// supabase/functions/stripe-payment/index.ts
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.21.0';
import Stripe from 'https://esm.sh/stripe@12.0.0?target=deno';

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type'
};

serve(async (req) => {
    // Handle CORS preflight request
    if (req.method === 'OPTIONS') {
        return new Response('ok', {
            headers: corsHeaders
        });
    }

    try {
        // Create a Supabase client
        const supabaseUrl = Deno.env.get('SUPABASE_URL');
        const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY');
        const supabase = createClient(supabaseUrl, supabaseKey);
        
        // Create a Stripe client
        const stripeKey = Deno.env.get('STRIPE_SECRET_KEY');
        const stripe = new Stripe(stripeKey);
        
        // Get the request body
        const { orderId, amount, currency = 'usd', paymentMethodId, customerId } = await req.json();
        
        // Validate required fields
        if (!orderId || !amount || !paymentMethodId) {
            throw new Error('Missing required fields: orderId, amount, or paymentMethodId');
        }
        
        // Get order details from Supabase
        const { data: order, error: orderError } = await supabase
            .from('orders')
            .select('*, restaurants(name)')
            .eq('id', orderId)
            .single();
            
        if (orderError || !order) {
            throw new Error('Order not found');
        }
        
        // Create payment intent with Stripe
        const paymentIntent = await stripe.paymentIntents.create({
            amount: Math.round(amount * 100), // Convert to cents
            currency: currency,
            payment_method: paymentMethodId,
            confirmation_method: 'manual',
            confirm: true,
            description: `Food order from ${order.restaurants?.name || 'Restaurant'} - Order #${order.order_number}`,
            metadata: {
                orderId: orderId,
                orderNumber: order.order_number,
                restaurantId: order.restaurant_id,
                userId: order.user_id
            },
            return_url: `${supabaseUrl}/order-success?order_id=${orderId}`
        });
        
        // Update order with payment intent details
        const { error: updateError } = await supabase
            .from('orders')
            .update({
                payment_intent_id: paymentIntent.id,
                payment_status: paymentIntent.status,
                updated_at: new Date().toISOString()
            })
            .eq('id', orderId);
            
        if (updateError) {
            console.error('Error updating order:', updateError);
        }
        
        // Return the payment intent
        return new Response(JSON.stringify({
            success: true,
            paymentIntent: {
                id: paymentIntent.id,
                status: paymentIntent.status,
                client_secret: paymentIntent.client_secret,
                amount: paymentIntent.amount,
                currency: paymentIntent.currency
            },
            order: {
                id: order.id,
                order_number: order.order_number,
                status: order.status
            }
        }), {
            headers: {
                ...corsHeaders,
                'Content-Type': 'application/json'
            },
            status: 200
        });
        
    } catch (error) {
        console.error('Payment processing error:', error);
        return new Response(JSON.stringify({
            success: false,
            error: error.message || 'Payment processing failed'
        }), {
            headers: {
                ...corsHeaders,
                'Content-Type': 'application/json'
            },
            status: 400
        });
    }
});