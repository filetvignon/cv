import pdftotext

# Load your PDF
with open("src/modernpro/modernpro.pdf", "rb") as f:
    pdf = pdftotext.PDF(f)


# Iterate over all the pages
for page in pdf:
    print(page)

# Read all the text into one string
# print("\n\n".join(pdf))