# envguard

Guarding your application ENV variables and fail fast if there is an unset env variable which is necessary for your application.

Lets say you might want to connect to a database and your credentials are in ENV variables. You'll use something like this:

    MYSQL_USERNAME=user \
    MYSQL_PASSWORD=password \
    java -jar ./build/libs/envguard-1.0-SNAPSHOT.jar
    
This is great but you might be in trouble if you 

 - have to run your application in an environment where these variables are already defined.
 - have a script or something beforehand, which dynamically creates these values. 
 
Moreover you must wait until the whole application starts in order to make sure that every ENV variable are set.

So you might want to describe the list of the necessary ENV variables, and fail fast if there is at least one which is unset.

## Usage of envguard

In order to start, you have to create a `environment.variables` file next to `envguard.sh`. In this file you must specify the list of your ENV variables separated by a newline. Lines beginning with # are processed as comments and ignored. Blank lines are ignored. So in this case we'll have a `environment.variables` file with the following content:
    
    # Database related variables
    MYSQL_USERNAME
    MYSQL_PASSWORD

Okay, let's start an application which must apply these variables and you forgot to setup the MYSQL_PASSWORD.

Without envguard

    export MYSQL_USERNAME=username; \
    java -jar envguard-1.0-SNAPSHOT.jar
    
You'll have this output

    Hello, world username with null!

With envguard

    export MYSQL_USERNAME=username; \
    ./envguard.sh && \
    java -jar envguard-1.0-SNAPSHOT.jar

You'll have this one:

    MYSQL_USERNAME value is : username
    MYSQL_PASSWORD is empty. Terminating.
    
TODO

 - Indicate and mask secret values (passwords)
 - Introducing silent mode

# Licensing 

Please see LICENSE file

# Contact

Zoltan Polgar - pozo@gmx.com

Please do not hesitate to contact me if you have any further questions.