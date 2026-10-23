<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="annexe.GenererEtat"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%> 
<%@page import="bean.TypeObjet"%> 
<%@page import="affichage.Liste"%> 
<%@page import="affichage.*"%> 
<%@page import="mg.cnaps.compta.*"%> 
<%@page import="bean.*" %>
<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "annexe.GenererEtat", titre = "Filtre Balance";
        GenererEtat genererEtat = new GenererEtat();
        genererEtat.setNomTable("genereretat");
        PageInsert pi = new PageInsert(genererEtat, request, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[6];
        
        ComptaExercice exercice = new ComptaExercice();
        exercice.setNomTable("COMPTA_EXERCICE");
        liste[0] = new Liste("exercice",exercice,"remarque","id");

        TypeObjet typeCompte = new TypeObjet();
        typeCompte.setNomTable("COMPTA_TYPE_COMPTE");
        liste[1] = new Liste("typeCompte",typeCompte,"val","id");
        
        liste[2] = new Liste("moisDebut");
        liste[2].makeListeMois();

        liste[3] = new Liste("moisFin");
        liste[3].makeListeMois();

        liste[4] = new Liste("typeEtat");
        String[] valeur = {"1","2"};
        String[] affiche = {"Balance","Grand Livre"};
        liste[4].ajouterValeur(valeur,affiche);
 
        liste[5] = new Liste("etat");
        String[] valeur1 = {"0","11","1"};
        String[] affiche1 = {"Tous","Visee","Non Visee"};
        liste[5].ajouterValeur(valeur1,affiche1);


        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("typeCompte").setLibelle("Type de Compte");
        pi.getFormu().getChamp("typeEtat").setLibelle("Type Etat");

        pi.getFormu().getChamp("moisDebut").setLibelle("Mois debut");
        pi.getFormu().getChamp("moisFin").setLibelle("Mois Fin");

        pi.getFormu().getChamp("duCompte").setLibelle("Du Compte");
        affichage.Champ[] champ = new affichage.Champ[1];
        champ[0] = pi.getFormu().getChamp("duCompte");
        affichage.Champ.setAutocomplete(champ,"libelle","compte","compta_compte"," AND typecompte='1'");

        pi.getFormu().getChamp("auCompte").setLibelle("Au Compte");
        affichage.Champ[] champ1 = new affichage.Champ[1];
        champ1[0] = pi.getFormu().getChamp("auCompte");
        affichage.Champ.setAutocomplete(champ1,"libelle","compte","compta_compte"," AND typecompte='1'");pi.preparerDataFormu();
        
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>
    <form action="<%=pi.getLien()%>?but=compta/etat/apres-balance-filtre.jsp" method="post">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
        out.println(pi.getHtmlAddOnPopup());
    %>
    </form>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
%>
    <script language="JavaScript"> 
        alert('<%=e.getMessage()%>');
        history.back();
    </script>

<% }%>
