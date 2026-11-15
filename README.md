# KYHA_DSO26_K3-Inlamningsuppgift1_Stig_Rudeholm

> **ER-diagram:** Skapa ett professionellt ER-diagram över databasen med hjälp av Lucidchart. Markera tydligt primärnycklar (PK), främmande nycklar (FK) och relationstyper (t.ex. 1:M eller M:N upplöst via en kopplingstabell).

Ett ER-diagram finns inkluderat i repot, både som `pdf`och `png`.

> **Normalisering:** Databasen ska vara strukturerad enligt tredje normalformen (3NF). Skriv en kort text (max en halvsida) där du motiverar varför din design uppfyller 1NF, 2NF och 3NF.

Min design uppfyller 1NF, 2NF, och 3NF därför att:

- Ingen tabell är beroende av att dess rader är i någon speciell ordning.
- Inga kolumner innehåller mixade datatyper.
- Alla tabeller har primärnycklar.
- Inga tabeller innehåller "repeterande grupper" av data.
- Varje tabell är fokuserad och innehåller bara kolumner som är relevanta för respektive nyckel.
- Alla kolumner är beroende av sin tabells primärnyckel och ingenting annat.