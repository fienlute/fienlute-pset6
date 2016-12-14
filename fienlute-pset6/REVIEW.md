Code Review door Barbara Boeters
14 december 2016

1. names: er zijn een aantal namen die erg op elkaar lijken in de verschillende view controllers, waardoor het niet altijd duidelijk is.
2. headers: mag wat meer informatie bij over wat je allemaal gebruikt in de code.  
3. comments: er zijn een aantal basic comments, maar dat mag veel uitgebreider zodat een ander de code kan begrijpen.
4. layout: zorg dat je code die uitgecommend is weg haalt als je het niet meer gaat gebruiken. 
5. formatting: ziet er goed uit, let bijvoorbeeld bij ThirdViewController op de enters en de goede indentatie. 
6. flow: je code kan beter georganiseerd worden zodat het overzichtelijker is. Maak meer verschillende files aan zodat je weet wat waar staat en wat je daaruit kunt gebruiken. 
7. idiom: je zou errors nog beter kunnen handelen. Zorg er bijvoorbeeld voor dat als iemand een niet bestaand land invoert, dat je dan een popup geeft. 
8. expressions: let op dat je var en let goed gebruikt, je krijgt hier nog wat errors over. 
9. decomposition: er zijn geen shared variables te zien. je hebt wel variabelen die door verschillende routines worden gebruikt. 
10.modularization: je zou grote stukken code in apparte functies kunnen zetten en kunnen aanhalen zodat het overzichtelijker is wat je met een button doet, zoals bij je API in je SecondViewController. 
