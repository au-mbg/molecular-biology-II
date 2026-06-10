from IPython.display import HTML, display


def check_answer(answers: list[str]):
    # Final cell to check answer

    correct_answers = ['CAEDB', '!', '1', 'A', 'C', 'B', 'A']
    correct_code = 'CAEDB!1ACBA'
    answer = ''.join(answers)

    # Check if the entered code is correct
    if answer == correct_code:
        display(HTML("<h1 style='color: green;'>🎉 Correct! Great job! 🎉</h1>"))
        display(HTML("<img src='https://media.giphy.com/media/X9izlczKyCpmCSZu0l/giphy.gif' width='300'>"))  # Celebration GIF
    else:

        for i, (a, c) in enumerate(zip(answers, correct_answers)):
            if a != c:
                display(HTML(f"<h2 style='color: orange;'>Question {i+1} is incorrect. Please review your answer.</h2>"))

        display(HTML("<h1 style='color: red;'>Incorrect. Try again!</h1>"))
        display(HTML("<img src='https://media.giphy.com/media/CoND5j6Bn1QZUgm1xX/giphy.gif' width='300'>"))