const express = require('express');
const mongoose = require('mongoose');

// Connect to MongoDB
mongoose.connect('mongodb://localhost/test', { useNewUrlParser: true, useUnifiedTopology: true });

// Define a schema
const MessageSchema = new mongoose.Schema({
    text: String
});

// Create a model
const Message = mongoose.model('Message', MessageSchema);

const app = express();

app.get('/', async (req, res) => {
    // Create a new message
    const message = new Message({ text: 'Hello, World!' });
    await message.save();

    res.send('Message saved to MongoDB!');
});

app.listen(3000, () => console.log('App is listening on port 3000'));