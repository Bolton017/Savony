<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 2025-04-01
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>

<%@page import="affichage.PageRecherche"%>
<%@ page import="fabrication.FabricationCpl" %>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>

<% try{
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    FabricationCpl t = new FabricationCpl();
    String nomTable = "FABRICATIONCPL";
        if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("etat");
        }
        t.setNomTable(nomTable);

    String listeCrt[] = {"id", "lanceparLib", "cibleLib", "remarque", "libelle", "daty","idOf","idOffille"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "lanceparLib", "cibleLib", "remarque", "libelle", "daty","idOf","idOffille","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Fabrications");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fabrication/fabrication-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idOf").setLibelle("Id Ordre de fabrication");
    pr.getFormu().getChamp("idOffille").setLibelle("Id Ordre de fabrication fille");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("lanceparLib").setLibelle("Lanc&eacute;e par");
    pr.getFormu().getChamp("cibleLib").setLibelle("Cible");
    pr.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=fabrication/fabrication-saisie.jsp&acte=update");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=fabrication/fabrication-fiche.jsp" , pr.getLien() + "?but=fabrication/ordre-fabrication-fiche.jsp", pr.getLien() + "?but=fabrication/ordre-fabrication-details-fiche.jsp"};
    String colonneLien[] = {"id" ,"idOf","idOffille"}; // Colonne contenant un lien, passé comme paramètre dans l'URL
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Remplacer le nom de l'attribut passé dans l'URL, par exemple passer 'idObjet' au lieu de 'id' du colonneLien
    String[] urlLienMultiple = {"id", "idOf","idOffille"};
    String[] urlLienAffiche = {"id", "id","id"};
    //String[] attributLien = {"id"};
    //pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setUrlLienAffiche(urlLienAffiche);
    pr.getTableau().setUrlLien(urlLienMultiple);

    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID", "Lanc&eacute;e par", "Cible", "Remarque", "D&eacute;signation", "Date","Id ordre de fabrication","Id Ordre de fabrication fille","&eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("fabrication/inc/fabrication-details.jsp&id=");
    String[] etatVal = {"FABRICATIONCPL","FABRICATIONCPLCREE", "FABRICATIONCPLVISEE", "FABRICATIONCPLANNULE","FABRICATIONCPLENTAMEE","FABRICATIONCPLBLOQUEE","FABRICATIONCPLBTERMINEE"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)","Valid&eacute;e(s)","Annul&eacute;e(s)","Entam&eacute;e(s)","Bloqu&eacute;e(s)","Termin&eacute;e(s)"};
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=fabrication/fabrication-saisie.jsp&currentMenu=MENUDYN0304008\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une fabrication</a>"
    );

%>
<script>
    function changerDesignation() {
        document.getElementById("bdlc-liste--form").submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdlc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-4 nopadding">
                    <label for="etat" class="input-label">&Eacute;tat</label>
                    <select name="etat" id="etat" class="form-control" onchange="changerDesignation()">
                        <%
                            for(int i=0; i<etatVal.length; i++){
                                String selected = "";
                                if(etatVal[i].equalsIgnoreCase(t.getNomTable())){
                                    selected = "selected";
                                }
                        %>
                        <option value="<%=etatVal[i]%>" <%=selected%>><%=etatAff[i]%></option>
                        <%
                            }
                        %>
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



