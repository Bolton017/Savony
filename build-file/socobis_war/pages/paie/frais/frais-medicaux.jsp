  <%@page import="affichage.Liste"%>
<%-- 
    Document   : frais-medicaux.jsp
    Created on : Oct 15, 2024, 12:04:14 PM
    Author     : Tsiky
--%>

<%@page import="paie.frais.FraisMedicaux"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<% 
    try{
        String mois_lib = (request.getParameter("mois_lib")!= null)?request.getParameter("mois_lib"):FraisMedicaux.convertirEnMois(Utilitaire.getMoisEnCours());
        String annee= (request.getParameter("annee")!= null)?request.getParameter("annee"):String.valueOf(Utilitaire.getAneeEnCours());
        String mois = FraisMedicaux.convertirEnNumeroMois(mois_lib);
        
        String nomProjet = "Fer",
               nomVue = "frais_medicaux_all",
               titre = "Liste frais medicaux",
               nomPage = "paie/frais/frais-medicaux.jsp";
        String [] listeCrt = {"moislib","annee"},
                  listeInt = null,
                  libEntete = {"matricule","nom","poste","dateembauche","numero_cnaps","total_brut","frais_medicaux"},
                  libEnteteAffiche = {"N°MATRICULE","NOM","POSTE","Date d'embauche","N°CNAPS","brut","FM"};
        
        FraisMedicaux objet = new FraisMedicaux();
        objet.setNomTable(nomVue);
        
        PageRecherche pr = new PageRecherche(objet, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        
        affichage.Liste[] liste = new affichage.Liste[1];
        String[] valeurs =  {"%","Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre","13eme Mois","13eme Mois BIS"};
        String[] affiches = {"Tous","Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre","13eme Mois","13eme Mois BIS"};
        liste[0] = new Liste("moislib" ,affiches,valeurs);
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pr.getFormu().getChamp("moislib").setLibelle("Mois");
        pr.setApres(nomPage);
        String[] colSomme = {"total_brut","frais_medicaux"};
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%=titre%></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%=nomPage%>" method="post" name="<%=nomProjet%>" id="<%=nomProjet%>">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <a class="btn btn-warning pull-right" href="${pageContext.request.contextPath}/ExportServlet?action=imprimerFraisMedicaux&mois=<%=mois%>&annee=<%=annee%>" class="btn btn-default pull-right">Imprimer PDF</a>
        <%
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
        %>
    </section>
  
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> 
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
