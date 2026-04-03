from openai import OpenAI
import os

with open('openai_key.txt', 'r') as file:
    key = file.read().strip()

OPENAI_KEY = key

def llm(model, prompt, temperature):
    client = OpenAI(api_key=OPENAI_KEY)
    kwargs = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}]
    }
    if not model.startswith("gpt-5"):
        kwargs["temperature"] = temperature
    response = client.chat.completions.create(**kwargs)
    return response.choices[0].message.content

def llm_messages(model, messages, temperature):
    client = OpenAI(api_key=OPENAI_KEY)
    kwargs = {
        "model": model,
        "messages": messages
    }
    if not model.startswith("gpt-5"):
        kwargs["temperature"] = temperature
    response = client.chat.completions.create(**kwargs)
    return response.choices[0].message.content

if __name__ == "__main__":
    prompt = "hi"
    print(llm("gpt-4o-mini-2024-07-18", prompt)) 