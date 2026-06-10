from IPython.display import HTML, display
import hashlib


def check_answer(entered_code):
    # Final cell to check answer
    correct_code = '5ef7327c49021d667b9333fae01f7ff3b9d62d83b325807c94bfdafaa14d9450'

    hashed_code = hashlib.sha256(entered_code.strip().upper().encode()).hexdigest()

    # Check if the entered code is correct
    if hashed_code == correct_code:
        display(HTML("<h1 style='color: green;'>🎉 Correct! Great job! 🎉</h1>"))
        display(HTML("<img src='https://media.giphy.com/media/X9izlczKyCpmCSZu0l/giphy.gif' width='300'>"))  # Celebration GIF
    else:
        display(HTML("<h1 style='color: red;'>Incorrect. Try again!</h1>"))
        display(HTML("<img src='https://media.giphy.com/media/CoND5j6Bn1QZUgm1xX/giphy.gif' width='300'>"))