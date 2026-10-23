<%-- 
    Document   : congeDroit-liste
    Created on : 1 d?c. 2020, 09:42:10
    Author     : mariano
--%>

<%@page import="paie.employe.PersonneGainSortieReste"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<% 
    PersonneGainSortieReste base = new PersonneGainSortieReste();
    
    String libEntete[] = {"id",  "matricule", "cturgence_nom_prenom", "gain", "montant", "reste"};
    String listeCrt[] = {"id", "matricule", "cturgence_nom_prenom", "gain", "montant", "reste"};
    String listeInt[] = {"gain", "montant", "reste"};
    
    PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    pr.getFormu().getChamp("cturgence_nom_prenom").setLibelle("Personnel");
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("gain1").setLibelle("Gain min");
    pr.getFormu().getChamp("gain2").setLibelle("Gain max");
    pr.getFormu().getChamp("montant1").setLibelle("Sortie min");
    pr.getFormu().getChamp("montant2").setLibelle("Sortie max");
    pr.getFormu().getChamp("reste1").setLibelle("Reste min");
    pr.getFormu().getChamp("reste2").setLibelle("Reste max");
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.setApres("paie/frais/personneGainSortieReste-liste.jsp");
    String[] colSomme = {"gain", "montant", "reste"};
    pr.creerObjetPage(libEntete, colSomme);
%>
<script>
    function changerDesignation() {
        document.liste.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste gain, sortie, reste par personne</h1>
    </section>
    <section class="content">
        <form action='<%=pr.getLien() + "?but=" + pr.getApres() %>' method="post" name="liste" id="liste">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <%  
            String lienTableau[] = {};
            String colonneLien[] = {};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            
            String[] colSommeAff = {"", "Nombre", "Gain total", "Sortie totale", "Reste totale"};
            pr.getTableauRecap().setLibelleAffiche(colSommeAff);
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            String libEnteteAffiche[] = {"ID", "Matricule", "Personnel", "Gain", "Sortie", "Reste"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>


