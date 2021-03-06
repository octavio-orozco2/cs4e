Installation
============
The following instructions will set up a more complex bitstarter than the
one you've done to date. Now you will be recording orders to a database.
The following commands are to be executed on your EC2 remote machine.

```sh
git clone git@github.com:octavio-orozco2/cs4e.git
cd cs4e
./setup-ssjs.sh
```
Rembember to logout and log back in, to enable node with packages:

```sh
exit 
```


Local and Remote Testing
========================
Once you have done this you will need to :
 

1. Update the `.env` file. You either copy the `.env` file which already includes the API key and port number:

```bash
[you@local cs4e repo] $ scp .env h1:~/cs4e
```

or you edit the `.env` file to include your API key from
http://coinbase.com/account/integrations so that it looks like this:

```bash
[you@ec2~/bitstarter]$head .env
COINBASE_API_KEY=cb27e2ef0a8e872f792612d4d57937e70476ab8041455b00b35d1196cf80f50d
PORT=8080
```


2. Then you can run the server locally and preview at URLs like http://ec2-54-213-131-228.us-west-2.compute.amazonaws.com:8080 as follows:

```sh
foreman start
```

Try placing some orders and then going to the "/orders" URL at the top to
try it out. Note that you will get an "invalid api key" error if you didn't
do the `.env` step above.


3. For remote servers, deploy and push configuration variables

Using only one branch:

```sh
git push heroku master
heroku config:push
```

Using three branches:
```sh
heroku config:push --remote staging-heroku
heroku config:push --remote production-heroku
git push staging-heroku staging:master
git push production-heroku master:master
```

Then you can go to a URL like http://cs4e.herokuapp.com or to
http://www.cs4e.com and submit orders to test it out.
Note again that you will get an "invalid api key"
error if you didn't do the `.env` step above.

