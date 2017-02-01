For Ngrok see this url or run the ngrok in same url

Follow the url
https://launchschool.com/blog/basic-paypal-checkout-processing-in-rails
............................................................


Expose your service to be accessed by Paypal

If we think a while we can realize that notification_url and return_url can not be accessed from Paypal because they are not exposed in the public internet, they are in our localhost.

We will use the Ngrok Service for tunnelling our local application to a Ngrok subdomain. So we will be able to allow Paypal to send a HTTP POST to our localhost and test our payment process locally.

First install Ngrok downloading it for your system. Or just run your package manager if you are on Linux:

1

	

sudo apt-get install ngrok-client

Now you can publish your application just running the command: ngrok 3000, since the rails port is 3000.

It will respond with a URL, http://3c99b47d.ngrok.com in my case. This is the app_host you should configure in your ‘config/secrets.yml’ file. Replace app_host: http://our_ngrok_url by app_host: http://3c99b47d.ngrok.com.