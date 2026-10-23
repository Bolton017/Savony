<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 25/07/2025
  Time: 15:22
  To change this template use File | Settings | File Templates.
--%>
<%@page import="stock.TransfertStockCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="magasin.Magasin"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="user.UserEJB" %>
<%@ page import="prevision.Service" %>
<% try{
    TransfertStockCpl stock = new TransfertStockCpl();
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
                stock.setNomTable(request.getParameter("etat"));
        }else{
            stock.setNomTable("TransfertStockCpl");
        }
    String listeCrt[] = {"id","designation","idMagasinDepart","idMagasinArrive", "idDepartementDepart", "idDepartementArrive", "daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","designation","idMagasinDepartlib","idMagasinArrivelib","idDepartementLibDepart", "idDepartementLibArrive","daty","etatlib"};
    PageRecherche pr = new PageRecherche(stock, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des transferts Envoy&eacute;s");

    // Initialisation Liste
    Liste[] listes = new Liste[4];
    Magasin m = new Magasin();
    m.setNomTable("magasinpoint");
    listes[0] = new Liste("idMagasinArrive", m, "val", "id");
    listes[1] = new Liste("idMagasinDepart", m, "val", "id");
    listes[2] = new Liste("idDepartementDepart", new Service(), "libelle", "id");
    listes[3] = new Liste("idDepartementArrive", new Service(), "libelle", "id");

    UserEJB userEJB = (user.UserEJB) session.getValue("u");
    pr.setUtilisateur(userEJB);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/transfertstock/transfertstock-depart-liste.jsp");
    pr.getFormu().changerEnChamp( listes );
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idMagasinDepart").setLibelle("Magasin de d&eacute;part");
    pr.getFormu().getChamp("idMagasinArrive").setLibelle("Magasin d'arriv&eacute;e");
    pr.getFormu().getChamp("idDepartementDepart").setLibelle("D&eacute;partement de d&eacute;part");
    pr.getFormu().getChamp("idDepartementArrive").setLibelle("D&eacute;partement d'arriv&eacute;e");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    Magasin magasin = userEJB.getMagasin();
    if(magasin!=null){
        pr.setAWhere(" and idMagasinDepart = '"+magasin.getId()+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=stock/transfertstock/transfertstock-saisie.jsp&acte=update");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=stock/transfertstock/transfertstock-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID","D&eacute;signation","Magasin de d&eacute;part","Magasin d'arriv&eacute;e", "D&eacute;partement de d&eacute;part", "D&eacute;partement d'arriv&eacute;e","Date","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
     function changerDesignation() {
        document.transfertlist.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="transfertlist" id="transfertlist">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" >
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("TransfertStockCpl") == 0) {%>
                        <option value="TransfertStockCpl" selected>Tous</option>
                        <% } else { %>
                        <option value="TransfertStockCpl" >Tous</option>
                        <% } %>
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("TransfertStockCpl_cree") == 0) {%>
                        <option value="TransfertStockCpl_cree" selected>Cr&eacute;&eacute;(s)</option>
                        <% } else { %>
                        <option value="TransfertStockCpl_cree">Cr&eacute;&eacute;(s)</option>
                        <% } %>
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("TransfertStockCpl_visee") == 0) {%>
                        <option value="TransfertStockCpl_visee" selected>Vis&eacute;(s)</option>
                        <% } else { %>
                        <option value="TransfertStockCpl_visee">Vis&eacute;(s)</option>
                        <% } %>
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("TransfertStockCpl_annulee") == 0) {%>
                        <option value="TransfertStockCpl_annulee" selected>Annul&eacute;(s)</option>
                        <% } else { %>
                        <option value="TransfertStockCpl_annulee">Annul&eacute;(s)</option>
                        <% } %>
                    </select>
                </div>
            </div>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
