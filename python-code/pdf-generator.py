# Simple code snippet to produce a PDF

# Let's import the needed package
from reportlab.pdfgen import canvas

my_canvas = canvas.Canvas("/mnt/artifacts/resultsmetadata-example.pdf")
my_canvas.drawString(100, 750, "Welcome to our self generated report based on an")
my_canvas.drawString(100, 735, "trigger in the Domino API when modifying the Metadata document!")
my_canvas.save()