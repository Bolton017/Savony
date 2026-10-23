<%@page import="vente.VenteLib"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>
<%@ page import="affichage.Liste" %>

<% try{
    VenteLib bc = new VenteLib();
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)", "Vis&eacute;(s)", "Annul&eacute;(s)"};

    bc.setNomTable("ventenonpaye");

    LocalDate today = LocalDate.now();
    LocalDate monday = today.withDayOfMonth(1);
    LocalDate sunday = today.withDayOfMonth(today.lengthOfMonth());

    if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("") != 0) {
        bc.setNomTable(request.getParameter("devise"));
    } else {
        bc.setNomTable("ventenonpaye");
    }
    String listeCrt[] = {"id", "designation","idClientLib","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "designation","idClientLib","idDevise","daty","montantttc","montantRevient","margeBrute","montantpaye", "montantreste","etatlib"};
    String libEnteteAffiche[] = {"id", "D&eacute;signation","Client","devise","Date","Montant TTC","montant de Revient","marge Brute","Montant Pay&eacute;","Montant Restant","&Eacute;tat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
   }
    pr.setTitre("Edition ristourne");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/vente-paiement-multiple.jsp");
    String[] colSomme = { "montantttc", "montantpaye", "montantreste","margeBrute" };
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");

    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.creerObjetPage(libEntete, colSomme);
    //pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=vente/vente-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?but=apresTarif.jsp&bute=vente/vente-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
    lienTab.put("Livrer",pr.getLien() + "?but=bondelivraison-client/apresLivraisonFacture.jsp&bute=vente/encaissement-modif.jsp" + pr.getFormu().getChamp("id").getValeur()+"");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String colonneLien[] = {"id"};
    String[] lib = {" ","Nombre", "Montant TTC", "Montant Pay&eacute;", "Montant restant","Marge Brute"};
    pr.getTableauRecap().setLibeEntete(lib);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
%>
<script>
    function changerDesignation() {
         document.getElementById("vente").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="row">
                    <div class="col-md-6">
                        <label class="input-label" for="devise">Devise :</label>
                        <select name="devise" class="champ form-control" id="devise" onchange="changerDesignation()" >
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("ventenonpaye") == 0) {%>
                            <option value="ventenonpaye" selected>Toutes</option>
                            <% } else { %>
                            <option value="ventenonpaye">Toutes</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("ventenonpaye_mga") == 0) {%>
                            <option value="ventenonpaye_mga" selected>AR</option>
                            <% } else { %>
                            <option value="ventenonpaye_mga">AR</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("ventenonpaye_eur") == 0) {%>
                            <option value="ventenonpaye_eur" selected>EUR</option>
                            <% } else { %>
                            <option value="ventenonpaye_eur">EUR</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("ventenonpaye_usd") == 0) {%>
                            <option value="ventenonpaye_usd" selected>USD</option>
                            <% } else { %>
                            <option value="ventenonpaye_usd">USD</option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="input-label" for="etat">&Eacute;tat :</label>
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                            <%
                                for (int i = 0; i < etatAff.length; i++) {
                            %>
                            <% if (request.getParameter("etat") != null
                                    && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) { %>

                            <option value="<%= etatVal[i] %>" selected>
                                <%= etatAff[i] %>
                            </option>

                            <% } else { %>

                            <option value="<%= etatVal[i] %>">
                                <%= etatAff[i] %>
                            </option>

                            <% } %>
                            <% } %>
                        </select>
                    </div>
                </div>
            </div>

        </form>
        <br>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <form action="<%=pr.getLien()%>?but=ristourne/ristourne-saisie.jsp" method="post" name="vente" id="vente">
        <input type="hidden" value="<%=pr.getLien()%>" name="lien">
        <%
            out.println(pr.getTableau().getHtmlWithCheckbox());
            out.println(pr.getBasPage());
        %>
        </form>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
