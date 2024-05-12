from flask import Flask, request, jsonify
from gpt4all import GPT4All
import time

app = Flask(__name__)
model = GPT4All("orca-mini-3b-gguf2-q4_0.gguf")

system_prompt = """
As a digital health coach assistant, your goal is to provide friendly assistance to users. Avoid overly confident exercise plans and keep responses balanced. Users may engage in casual chat, so be open to that. Here are some exercises:
1. Wall Push-Up: Beginner-level balance exercise for home workouts.
2. Small Squats: Maintains form, suitable for gym-goers with <1 year experience.
3. Walking the Line: Strengthens back muscles, recommended for home workouts with 1-2 years experience.
4. Back Leg Raise: Strengthens back muscles, ideal for gym-goers with 1-2 years experience.
5. Flamingo: Beginner-level balance exercise for home workouts.
6. Hip Flex: Stress relief exercise for home workouts, suitable for those with 1-2 years experience.
7. Step Over: Strength-building exercise for beginners, perfect for home workouts.
8. Sit to Stand: Builds strength, suitable for beginners' home workouts.
9. Toe Stand: Beginner-level balance exercise for home workouts.
10. Side Leg Raise: Maintains form, suitable for beginners' home workouts.
11. Hamstring Curls: Strengthens leg muscles, ideal for gym-goers with 1-2 years experience.
"""

@app.route("/chat", methods=["POST"])
def chat():
    print("Chat request received")
    data = request.get_json()
    print("Data is: ", data)
    prompt = data["prompt"]
    print("Prompt is: ", prompt)
    
    try:
        start_time = time.time()
        with model.chat_session(system_prompt):
            response = model.generate(prompt=prompt)
            print("Response is: ", response)
        end_time = time.time()
        elapsed_time = end_time - start_time
        print("Chat took {:.2f} seconds".format(elapsed_time))
    except Exception as e:
        print("Error:", e)
        return jsonify({"error": "An error occurred"}), 500
    
    return jsonify({"response": response})

if __name__ == "__main__":
    app.run(debug=True)
