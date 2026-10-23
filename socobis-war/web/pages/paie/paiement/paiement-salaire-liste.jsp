<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.paiement.PaiementSalaireLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="paie.log.LogService" %>

<% try{ 
    PaiementSalaireLib o = new PaiementSalaireLib();
    o.setNomTable("PAIEMENT_SALAIRE_LIB");

    String etatParam = request.getParameter("etat");

    if(etatParam != null && etatParam.compareToIgnoreCase("") != 0) {
        o.setNomTable(etatParam);
    }

    String[] listeCrt = {"bu", "uniteLib", "idSectionLib", "directionLib",  "modePaiementLib","matricule", "nomPersonnel", "daty", "montant"};
    String[] listeInt = {"daty", "montant"};
    String[] libEntete = {"id", "idPersonnel","matricule","nomPersonnel","buLib",  "uniteLib", "idSectionLib", "directionLib", "montant","modePaiementLib","daty","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setNpp(50);
    pr.setTitre("Liste des paiement de salaire");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));

    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/paiement/paiement-salaire-liste.jsp");
    
    Liste[] liste = new Liste[5];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("BUSINESS_UNITE");
    liste[0] = new Liste("bu",liste0,"val","id");
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("MODEPAIEMENT");
    liste[1] = new Liste("modePaiementLib",liste1,"val","val");
    TypeObjet directionLib = new TypeObjet();
    directionLib.setNomTable("log_direction");
    liste[2] = new Liste("directionLib", directionLib, "val", "val");
    LogService idSectionLib = new LogService();
    idSectionLib.setNomTable("LOG_SERVICE");
    liste[3] = new Liste("idSectionLib", idSectionLib, "libelle", "libelle");
    TypeObjet uniteLib = new TypeObjet();
    uniteLib.setNomTable("LOG_UNITE");
    liste[4] = new Liste("uniteLib", uniteLib, "val", "val");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("bu").setLibelle("BU");
    pr.getFormu().getChamp("modePaiementLib").setLibelle("Mode de paiement");
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("nomPersonnel").setLibelle("Personnel");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("montant1").setLibelle("Montant min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant max");

    pr.getFormu().getChamp("directionLib").setLibelle("Direction");
    pr.getFormu().getChamp("uniteLib").setLibelle("Unit&eacute;");
    pr.getFormu().getChamp("idSectionLib").setLibelle("Section/Service");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"ID", "ID Personnel","Matricule","Personnel","BU", "Unit&eacute;", "Section/Service", "Direction","Montant","Mode de paiement","Date","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String lienTableau[] = {pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
    String colonneLien[] = {"idPersonnel"};
    String attributLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setColonneLien(colonneLien);

    String[] etatVal = {"", "PAIEMENT_SALAIRE_IMPAYE", "PAIEMENT_SALAIRE_OVGENERE", "PAIEMENT_SALAIRE_PAYE"};
    String[] etatAff = {"Tous", "Impay&eacute;", "OV G&eacute;n&eacute;r&eacute;", "Pay&eacute;"};
%>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>

    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            String currentEtat = request.getParameter("etat");
                            if (currentEtat == null || currentEtat.equals("")) {
                                currentEtat = "!= 100";
                            }
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(etatVal[i].equalsIgnoreCase(currentEtat)) {%>
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
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        </br>
        <%
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