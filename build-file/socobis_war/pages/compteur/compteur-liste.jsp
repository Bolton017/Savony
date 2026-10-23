
<%@page import="affichage.PageRecherche"%>
<%@ page import="compteur.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    CompteurLib t = new CompteurLib();
    String nomTable = "COMPTEURLIB";
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        nomTable = request.getParameter("etat");
    }
    t.setNomTable(nomTable);

    String listeCrt[] = {"id", "idFabrication", "idMachine", "daty", "idOrigine"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "idFabrication", "nombre", "daty", "heure","debut","idFabricationLib","idMachineLib","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Compteurs");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compteur/compteur-liste.jsp");

    Liste[] listes = new Liste[2];
    Magasin m = new Magasin();
    m.setNomTable("magasin2");
    TypeObjet mag = new TypeObjet();
    mag.setNomTable("machine");
    listes[0] = new Liste("idOrigine", m, "val", "id");
    listes[1] = new Liste("idMachine", mag, "val", "id");
    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idFabrication").setLibelle("ID Fabrication");
    pr.getFormu().getChamp("idMachine").setLibelle("Machine");
    pr.getFormu().getChamp("idOrigine").setLibelle("Cuve origine");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=compteur/compteur-fiche.jsp" , pr.getLien() + "?but=fabrication/fabrication-fiche.jsp", pr.getLien() + "?but=magasin/magasin-fiche.jsp"};
    String colonneLien[] = {"id" ,"idFabrication","idOrigine"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String[] urlLienMultiple = {"id", "idFabrication","idOrigine"};
    String[] urlLienAffiche = {"id", "id","id"};

    pr.getTableau().setUrlLienAffiche(urlLienAffiche);
    pr.getTableau().setUrlLien(urlLienMultiple);

    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID", "ID Fabrication", "Compteur actuel", "Date", "Heure","D&eacute;but","Fabrication","Machine","Etat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatVal = {"COMPTEURLIB","COMPTEURLIBCREER", "COMPTEURLIBANNULER", "COMPTEURLIBVISER"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)","Annul&eacute;(s)","Valid&eacute;(s)"};
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=compteur/compteur-saisie.jsp&currentMenu=MENUDYN01908002\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un compteur</a>"
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



