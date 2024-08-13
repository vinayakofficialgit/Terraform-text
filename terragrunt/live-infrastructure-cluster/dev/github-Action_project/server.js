const express = require('express');

const app = express();

app.get('/api/get', (req,res) => {
    res.send({message : 'It Works, Nodejs and docker integrate The SonarQUBE AWS in Deployment'});
})

app.get('/api/get/user', (req,res) => {
    res.send({name : 'Dev', email: 'dev@gmail.com', 'role': 'Developer'});
})

app.listen(9000, (req,res) => {
    console.log('server running on port 9000')
})
