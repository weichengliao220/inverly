require('dotenv').config();
// app/javascript/index.js
const { GoogleGenerativeAI } = require("@google/generative-ai");

const apiKey = process.env.GOOGLE_API_KEY;
const genAI = new GoogleGenerativeAI(apiKey);

const args = process.argv.slice(2);
const name = args.join(' ');  // Join the arguments into a single string to handle spaces

const prompt = `Generate a 2 sentences resume about investing in an ETF that holds ${name}. Your answer will be displayed directly on the front end of my website. Make sure to explain in part what the company does and the benefits of inlcuding it in the etf`; // Customize the prompt as needed

const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

async function generate() {
  try {
    const result = await model.generateContent(prompt);
    console.log(result.response.text());  // Print the result to stdout
  } catch (error) {
    console.error("Error generating content:", error);
    process.exit(1);  // Exit with error status if something goes wrong
  }
}

generate();
