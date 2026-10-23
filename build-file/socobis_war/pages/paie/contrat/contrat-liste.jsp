<%@page import="paie.contrat.VueContrat"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<% 
    try{
    VueContrat base = new VueContrat();
  
    String libEntete[] = {"id", "matricule", "nom", "prenom","periode","type_contrat","dateembauche","date_fin_contrat"};
    String listeCrt[] = {"id", "matricule", "nom", "prenom","periode","date_fin_contrat","type_contrat","dateembauche"};
    String listeInt[] = {"periode","date_fin_contrat","dateembauche"};
    
    PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("prenom").setLibelle("Pr&eacute;nom");
    Liste[] liste=new Liste[1];
    TypeObjet typeContrat = new TypeObjet();
    typeContrat.setNomTable("TYPE_CONTRAT");
    liste[0]=new Liste("type_contrat",typeContrat,"VAL","VAL");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("type_contrat").setLibelle("Type de contrat");
    pr.getFormu().getChamp("periode1").setLibelle("P&eacute;riode Min");
    pr.getFormu().getChamp("periode2").setLibelle("P&eacute;riode Max");
    pr.getFormu().getChamp("date_fin_contrat1").setLibelle("Date de fin de contrat Min");
    pr.getFormu().getChamp("date_fin_contrat2").setLibelle("Date de fin de contrat Max");
    pr.getFormu().getChamp("dateembauche1").setLibelle("Date d'embauche Min");
    pr.getFormu().getChamp("dateembauche2").setLibelle("Date d'embauche Max");

    pr.setNpp(100);
    pr.setApres("paie/contrat/contrat-liste.jsp");
    String[] colSomme = {};
    pr.creerObjetPage(libEntete, colSomme);
    
%>
<script>
    function changerDesignation() {
        document.liste.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des contrats</h1>
    </section>
    <section class="content">
        <form action='<%=pr.getLien() + "?but=" + pr.getApres() %>' method="post" name="liste" id="liste">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <%  
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            String libEnteteAffiche[] = {"ID", "Matricule", "Nom", "Pr&eacute;nom","P&eacute;riode","Type de contrat","Date d'embauche","Date de fin de contrat"};
            String lienTableau[] = {pr.getLien() + "?but=paie/contrat/contrat-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% 
    }catch(Exception ex){
        ex.printStackTrace();
    }
%>


