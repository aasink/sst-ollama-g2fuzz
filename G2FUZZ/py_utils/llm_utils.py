import ollama
from ollama import Client, ResponseError

client = Client(host='http://localhost:11434', timeout=600)

def llm(model, prompt, temperature):
    for attempt in range(3):
        try:
            response = client.chat(
                model=model,
                messages=[{"role": "user", "content": prompt}],
                options={"temperature": temperature}
            )
            return response["message"]["content"]
        except (ResponseError, Exception) as e:
            print(f"Ollama request failed (attempt {attempt+1}/3): {e}")
    print("All 3 attempts failed, returning empty string")
    return ""

def llm_messages(model, messages, temperature):
    for attempt in range(3):
        try:
            response = client.chat(
                model=model,
                messages=messages,
                options={"temperature": temperature}
            )
            return response["message"]["content"]
        except (ResponseError, Exception) as e:
            print(f"Ollama request failed (attempt {attempt+1}/3): {e}")
    print("All 3 attempts failed, returning empty string")
    return ""

if __name__ == "__main__":
    prompt = "hi"
    print(llm("qwen2.5-coder:1.5b", prompt, 0.7))