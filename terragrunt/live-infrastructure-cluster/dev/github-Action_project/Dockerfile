    FROM ubuntu:18.04

    WORKDIR /app

    RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    && apt-get clean \
    nodejs 
    
    RUN apt install npm -y

    COPY package*.json /app


    COPY . .
    RUN npm install

    EXPOSE 9000



    CMD ["npm", "start"]
