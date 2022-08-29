# Simple code snippet to produce a PDF

# Add missing package
#import subprocess
#import sys

#def install(package):
#    subprocess.check_call([sys.executable, "-m", "pip", "install", reportlab])

# Let's import the needed package
from reportlab.pdfgen import canvas

my_canvas = canvas.Canvas("/mnt/artifacts/resultsmetadata-example.pdf")
my_canvas.drawString(100, 750, "Welcome to our self generated report based on an")
my_canvas.drawString(100, 735, "trigger in the Domino API when modifying the Metadata document!")
my_canvas.save()