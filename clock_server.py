import pygame
import time
from flask import Flask, request, jsonify

# Initialize Pygame clock 
pygame.init()
screen = pygame.display.set_mode((800, 480), pygame.NOFRAME)  # Adjust screen
pygame.display.set_caption("Digital Clock")
font = pygame.font.Font(None, 150)
clock = pygame.time.Clock()

#clock controll
app = Flask(__name__)


clock_running = True
custom_message = ""

#control clock (start/stop)
@app.route('/control', methods=['POST'])
def control_clock():
    global clock_running
    action = request.json.get("action")
    if action == "start":
        clock_running = True
        return jsonify({"status": "Clock started"})
    elif action == "stop":
        clock_running = False
        return jsonify({"status": "Clock stopped"})
    else:
        return jsonify({"error": "Invalid action"}), 400

# Route to update
@app.route('/message', methods=['POST'])
def update_message():
    global custom_message
    custom_message = request.json.get("message")
    return jsonify({"status": "Message updated"})

#Display Function
def display_clock():
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                exit()
        
        screen.fill((0, 0, 0))  #background

        if clock_running:
            current_time = time.strftime("%H:%M:%S")
            text = font.render(current_time, True, (255, 255, 255))  # W text
            screen.blit(text, (100, 150))  # Position time

        if custom_message:
            message_text = font.render(custom_message, True, (255, 0, 0))  # Red text 
            screen.blit(message_text, (100, 300))  # Position message 
        pygame.display.update()
        clock.tick(60)  #FPS

# Run the Flask
if __name__ == "__main__":
    from threading import Thread
    server_thread = Thread(target=lambda: app.run(host="0.0.0.0", port=5000))
    server_thread.daemon = True
    server_thread.start()

    # Run display
    display_clock()
