

<%@page import="utils.ConstanteAsync"%>
<%@page import="caisse.ReportCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<% try{ 
    String[] etatVal = {"","1","11","0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Valid&eacute;(s)","Annul&eacute;e(s)"};
    ReportCaisseCpl t = new ReportCaisseCpl();
    t.setNomTable("ouverturecaisse_cpl");
    String listeCrt[] = {"id","idCaisseLib","montant","montantTheorique","daty"};
    String listeInt[] = {"daty","montant","montantTheorique"};
    String libEntete[] = {"id","idCaisseLib","montant","montantTheorique","ecartCalc","daty","heure","typeReportLib", "etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste d'ouverture caisse");
    String awhere = "";
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        awhere += " and etat=" + request.getParameter("etat");
    }
    awhere += "and typereport = '"+ConstanteAsync.type_report_ouverture+"'";
    pr.setAWhere(awhere);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/ouveturecaisse/ouverturecaisse-liste.jsp");
    String[] colSomme = null;
    pr.getFormu().getChamp("idCaisseLib").setLibelle("Caisse");
    pr.getFormu().getChamp("montant1").setLibelle("Montant min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant max");
    pr.getFormu().getChamp("montantTheorique1").setLibelle("Montant th&eacute;orique min");
    pr.getFormu().getChamp("montantTheorique2").setLibelle("Montant th&eacute;orique max");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=caisse/ouveturecaisse/ouverturecaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Caisse","montant","Montant th&eacute;orique ","&Eacute;cart","date", "Heure","Type report","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=caisse/ouveturecaisse/ouverturecaisse-saisie.jsp&currentMenu=MENUDYN00151\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un ouverture de caisse</a>"
    );
%>
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" name="vente" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12" style="margin-top: 12px;">
                    <div class="col-md-2 nopadding" style="width: 271px" >
                        <label class="input-label" for="etat">&Eacute;tat :</label>
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < etatAff.length; i++ ){ %>
                            <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                            <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
            </div>
        </form>

        
        <div class="col-md-12 nopadding">
            <%
                out.println(pr.getTableauRecap().getHtml());
            %>
        </div>

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
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



