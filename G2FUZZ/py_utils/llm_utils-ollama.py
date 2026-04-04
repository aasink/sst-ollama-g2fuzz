import ollama

def llm(model, prompt, temperature):
    response = ollama.chat(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        options={"temperature": temperature}
    )
    return response["message"]["content"]

def llm_messages(model, messages, temperature):
    response = ollama.chat(
        model=model,
        messages=messages,
        options={"temperature": temperature}
    )
    return response["message"]["content"]

if __name__ == "__main__":
    prompt = "write some code that prints hello world and then a joke"
    print(llm("qwen2.5-coder:1.5b", prompt, 0.7))