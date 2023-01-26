from xml.dom import minidom

f = minidom.parse('germany50.xml')
nodes = f.getElementsByTagName('node')
xValues = f.getElementsByTagName('x')
yValues = f.getElementsByTagName('y')
cities = [(node.getAttribute('id'), (xValues[i].firstChild.nodeValue), (yValues[i].firstChild.nodeValue)) for i, node in enumerate(nodes)]

links = f.getElementsByTagName('link')
linkNodes = [(link.getElementsByTagName('source')[0].firstChild.nodeValue, link.getElementsByTagName('target')[0].firstChild.nodeValue) for link in links]

nodeNums = {}
for i, node in enumerate(nodes):
  nodeNums[node.getAttribute('id')] = i + 1

newCities = [(
  nodeNums[node.getAttribute('id')], 
  (xValues[i].firstChild.nodeValue), 
  (yValues[i].firstChild.nodeValue),
  node.getAttribute('id')
) for i, node in enumerate(nodes)]

with open('cities.txt', 'w') as f:
  f.write('id\tx\ty\tname\n')
  for city in newCities:
    f.write(str(city[0]) + '\t' + city[1] + '\t' + city[2] + '\t' + city[3] + '\n')

