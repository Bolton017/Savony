<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="carburant.GenerationCarburant" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="java.sql.Connection" %>

<% try{ 
    GenerationCarburant o = new GenerationCarburant();
    o.setNomTable("GENERATIONCARBURANT");
    String[] listeCrt = {"departement","personne","annee","semaine"};
    String[] listeInt = {"semaine"};
    String[] libEntete = {"personne","semaine","nbJour"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("G&eacute;n&eacute;ration Carburant");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("carteCarburant/generation-carburant.jsp");
    
    Liste[] liste = new Liste[1];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("DEPARTEMENT");
    liste[0] = new Liste("departement",liste0,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("departement").setLibelle("Departement");
    pr.getFormu().getChamp("personne").setLibelle("Personne");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pr.getFormu().getChamp("semaine1").setLibelle("Semaine min");
    pr.getFormu().getChamp("semaine2").setLibelle("Semaine max");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String departement = request.getParameter("departement");
    String personne = request.getParameter("personne");
    String annee = request.getParameter("annee");
    String semaine1 = request.getParameter("semaine1");
    String semaine2 = request.getParameter("semaine2");

    String[] libEnteteAffiche = {"Personne","Semaine","Nombre de jours"};
    pr.getTableau().setData((bean.ClassMAPTable[]) o.generationCarburantData(departement, personne, annee, semaine1, semaine2, null));
    pr.getTableau().transformerDataString();

    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <form action="<%=pr.getLien()%>?but=facturefournisseur/dmdachat/dmdachat-saisie.jsp" method="post" name="vente" id="vente">
            <input type="hidden" value="<%=pr.getLien()%>" name="lien">
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
                out.println(pr.getBasPage());
            %>
        </form>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

