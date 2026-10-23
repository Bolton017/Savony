<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="declaration.DeclarationTvaLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="declaration.LiaisonCodeImpotLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{
    LiaisonCodeImpotLib o = new LiaisonCodeImpotLib();
    o.setNomTable("LIAISONCODELib");
    String[] listeCrt = {"id","idCodeImpotLib","idcodeimpot","idcompte"};
    String[] listeInt = {};
    String[] libEntete = {"id","idcodeimpot","idCodeImpotLib","idcompte","formule","taxable"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des codes impôt - compte");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("declaration/liste-codeimpot-compte.jsp");
    pr.getFormu().getChamp("id").setLibelle("R&eacute;f.");
    pr.getFormu().getChamp("idcodeimpot").setLibelle("Code");
    pr.getFormu().getChamp("idcompte").setLibelle("Compte");
    pr.getFormu().getChamp("idCodeImpotLib").setLibelle("Libell&eacute;");

    String[] formuleVal = {"","debit","credit"};
    String[] formuleAff = {"Tous","D&eacute;bit","Cr&eacute;dit"};
    String[] taxableVal = {"","Oui","Non"};
    String aWhere = "";
    String formuleFiltre = request.getParameter("formule");
    if (formuleFiltre != null && !formuleFiltre.isEmpty() && java.util.Arrays.asList(formuleVal).contains(formuleFiltre)) {
        aWhere += " AND formule = '" + formuleFiltre + "'";
    }
    String taxableFiltre = request.getParameter("taxable");
    if (taxableFiltre != null && !taxableFiltre.isEmpty() && java.util.Arrays.asList(taxableVal).contains(taxableFiltre)) {
        aWhere += " AND taxable = '" + taxableFiltre + "'";
    }
    pr.setAWhere(aWhere);


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"R&eacute;f.", "Code","Libell&eacute;","Compte","Formule", "Taxable"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=declaration/saisie-codeimpot-compte.jsp&acte=update");
    lienTab.put("dupliquer", pr.getLien() + "?but=declaration/saisie-codeimpot-compte.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);

    String lienTableau[] = {pr.getLien() + "?but=declaration/fiche-codeimpot-compte.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.setApjSplitEnabled(false);
    pr.getFormu().setAnotherButton("<a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=declaration/saisie-codeimpot-compte.jsp&currentMenu=MENDYPAR001\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir des comptes par code imp&ocirc;t\n" +
            "                </a>");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" >
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        <div class="row col-md-12 nopadding">
            <div class="col-md-2 nopadding">
                <label class="input-label" for="formule">Formule :</label>
                <select name="formule" class="champ form-control" id="formule" onchange="changerDesignation()" >
                    <% for (int i = 0; i < formuleVal.length; i++) { %>
                    <option value="<%= formuleVal[i] %>" <%= formuleVal[i].equals(formuleFiltre == null ? "" : formuleFiltre) ? "selected" : "" %>><%= formuleAff[i] %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-2">
                <label class="input-label" for="taxable">Taxable :</label>
                <select name="taxable" class="champ form-control" id="taxable" onchange="changerDesignation()" >
                    <option value="" <%= taxableFiltre == null || taxableFiltre.isEmpty() ? "selected" : "" %>>Tous</option>
                    <option value="Oui" <%= "Oui".equals(taxableFiltre) ? "selected" : "" %>>Oui</option>
                    <option value="Non" <%= "Non".equals(taxableFiltre) ? "selected" : "" %>>Non</option>
                </select>
            </div>
            <div class="col-md-4"></div>
        </div>
        </form>
        <br>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

