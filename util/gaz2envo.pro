gaz2envo(G,E) :-
        rdf(G,owl:equivalentClass,WG),
        rdf(WG,rdf:type,WE),
        rdf(E,owl:equivalentClass,WE).

        
