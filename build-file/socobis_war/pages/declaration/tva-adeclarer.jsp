<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="mg.cnaps.compta.ComptaSousEcritureLib" %>

<% try{ 
    ComptaSousEcritureLib o = new ComptaSousEcritureLib();
    o.setNomTable("COMPTASOUSECRITUREND");
    String[] listeCrt = {"id","numero","journal","compte","libellePiece","debit","credit","daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","numero","journal","compte","daty","libellePiece","debit","credit"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;critures &agrave; d&eacute;clarer");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String paramSup = "&datydebut="+request.getParameter("datydebut");
    paramSup += "&datyfin="+request.getParameter("datyfin");
    paramSup += "&designation="+request.getParameter("designation");
    pr.setApres("declaration/tva-adeclarer.jsp"+paramSup);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("numero").setLibelle("Intitul&eacute;");
    pr.getFormu().getChamp("journal").setLibelle("Journal");
    pr.getFormu().getChamp("compte").setLibelle("Compte");
    pr.getFormu().getChamp("libellePiece").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
    pr.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");

    String[] colSomme = null;
    pr.setNpp(9999);
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Intitul&eacute;","Journal","Compte","Date","Libell&eacute;","D&eacute;bit","Cr&eacute;dit"};
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
        <form action="<%= pr.getLien()+"?but=declaration/apresDeclarerTva.jsp"%>" method="post">
            <input type="hidden" value="declaration/fiche-declaration-tva.jsp" name="bute" id="bute">
            <input type="hidden" value="<%=request.getParameter("datydebut")%>" name="datydebut" id="datydebut">
            <input type="hidden" value="<%=request.getParameter("datyfin")%>" name="datyfin" id="datyfin">
            <input type="hidden" value="<%=request.getParameter("designation")%>" name="designation" id="designation">
            <%
                pr.getTableau().setNameBoutton("D&eacute;clarer");
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

