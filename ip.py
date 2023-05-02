import requests
from bs4 import BeautifulSoup
response = requests.get('http://localhost:4040/api/tunnels')
soup = BeautifulSoup(response.content, 'html.parser')
indc = soup.text.find('public_url')
url = soup.text[indc+13:indc+39]
url = url.replace('tcp:','byond:')
with open("PublicURL.txt", "w+") as out:
    out.write(url)
print()
print('Public URL: ' + url)
print()
