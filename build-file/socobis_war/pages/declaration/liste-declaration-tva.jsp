<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="declaration.DeclarationTvaLib" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    DeclarationTvaLib o = new DeclarationTvaLib();
    o.setNomTable("DECLARATIONTVALIB");
    String[] listeCrt = {"id","designation","datydebut","datyfin","montantpayer"};
    String[] listeInt = {"datydebut","datyfin","montantpayer"};
    String[] libEntete = {"id","designation","datydebut","datyfin","montantpayer","payementLib","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des d&eacute;clarations ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("declaration/liste-declaration-tva.jsp");
    pr.getFormu().getChamp("id").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("datydebut1").setLibelle("Date de d&eacute;but min");
    pr.getFormu().getChamp("datydebut2").setLibelle("Date de d&eacute;but max");
    pr.getFormu().getChamp("datyfin1").setLibelle("Date de fin min");
    pr.getFormu().getChamp("datyfin2").setLibelle("Date de fin max");
    pr.getFormu().getChamp("montantpayer1").setLibelle("Montant pay&eacute; min");
    pr.getFormu().getChamp("montantpayer2").setLibelle("Montant pay&eacute; max");

    String aWhere = "";
    String etatFiltre = request.getParameter("etat");
    if ("1".equals(etatFiltre)) aWhere += " AND etat = 1";
    else if ("11".equals(etatFiltre)) aWhere += " AND etat = 11";
    String payementFiltre = request.getParameter("payementLib");
    if ("paye".equals(payementFiltre)) aWhere += " AND payementLib = 'Payé'";
    else if ("nonpaye".equals(payementFiltre)) aWhere += " AND payementLib = 'Non payé'";
    else if ("reporte".equals(payementFiltre)) aWhere += " AND payementLib = 'Reporté'";
    pr.setAWhere(aWhere);


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"R&eacute;f&eacute;rence","D&eacute;signation","Date de d&eacute;but","Date de Fin","Montant pay&eacute;","&Eacute;tat de Payement","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String lienTableau[] = {pr.getLien() + "?but=declaration/fiche-declaration-tva.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getFormu().setAnotherButton("<a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=declaration/declaration-tva.jsp&currentMenu=MENDYN176638DECL001\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir une d&eacute;claration de TVA\n" +
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
                <label class="input-label" for="etat">&Eacute;tat :</label>
                <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" >
                    <option value="" <%= etatFiltre == null || etatFiltre.isEmpty() ? "selected" : "" %>>Tous</option>
                    <option value="1" <%= "1".equals(etatFiltre) ? "selected" : "" %>>Cr&eacute;&eacute;</option>
                    <option value="11" <%= "11".equals(etatFiltre) ? "selected" : "" %>>Vis&eacute;</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="input-label" for="payementLib">&Eacute;tat de Payement :</label>
                <select name="payementLib" class="champ form-control" id="payementLib" onchange="changerDesignation()" >
                    <option value="" <%= payementFiltre == null || payementFiltre.isEmpty() ? "selected" : "" %>>Tous</option>
                    <option value="paye" <%= "paye".equals(payementFiltre) ? "selected" : "" %>>Pay&eacute;</option>
                    <option value="nonpaye" <%= "nonpaye".equals(payementFiltre) ? "selected" : "" %>>Non pay&eacute;</option>
                    <option value="reporte" <%= "reporte".equals(payementFiltre) ? "selected" : "" %>>Report&eacute;</option>
                </select>
            </div>
            <div class="col-md-4"></div>
        </div>
        </form>
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

