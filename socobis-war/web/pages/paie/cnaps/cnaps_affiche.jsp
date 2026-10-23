<%-- 
    Document   : cnaps_affiche
    Created on : 25 janv. 2023, 16:50:02
    Author     : tsikyrami
--%>

<%@page import="paie.cnaps.CnapsAfficheBis"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>

<%
    CnapsAfficheBis dr = new CnapsAfficheBis();
  
    if (request.getParameter("etat") != null && !request.getParameter("etat").equals("")) {
        dr.setNomTable(request.getParameter("etat"));
    } else {
        dr.setNomTable("CNAPS_T1");
    }
    

    String listeCrt[] = {"idpersonnel","matricule","numero_cnaps","annee","PERSONNEL"};
    String listeInt[] = {};
    String libEntete[] = {"IDPERSONNEL","MATRICULE","PERSONNEL","NUMERO_CNAPS","MOIS1","CNAPS_TRAVAILLEUR1","CNAPS_EMPLOYEUR1","MOIS2","CNAPS_TRAVAILLEUR2","CNAPS_EMPLOYEUR2","MOIS3","CNAPS_TRAVAILLEUR3","CNAPS_EMPLOYEUR3","COTISATION_TRAVAILLEUR","COTISATION_EMPLOYEUR","ANNEE"};
//    for (int i=0;i<libEntete.length;i++) {
//        System.out.println("ENTETE --------- "+libEntete[i]);
//    }
//    System.out.println("ETAT : "+request.getParameter("etat"));

    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/cnaps/cnaps_affiche.jsp");
    pr.setTitre("CNAPS");
    
    //affichage.Champ[] listes = new affichage.Champ[1];
    //TypeObjet m0 = new TypeObjet();
    //m0.setNomTable("log_direction");
    //listes[0] = new Liste("direction", m0, "val", "id");
    //pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("numero_cnaps").setLibelle("Num&eacute;ro cnaps");
     pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    //pr.getFormu().getChamp("direction").setLibelle("Direction");
    pr.getFormu().getChamp("idpersonnel").setLibelle("ID Personnel");
    pr.getFormu().getChamp("PERSONNEL").setLibelle("Personnel");

    String[] colSomme = {"COTISATION_TRAVAILLEUR","COTISATION_EMPLOYEUR"};
    pr.creerObjetPage(libEntete, colSomme);
    String libEnteteAffiche[] = {"Id Personnel","Matricule", "Personnel", "Num&eacute;reo CNAPS", "Imposable 1er Mois", "CNAPS TRAVAILLEUR 1er Mois", "CNAPS EMPLOYEUR 1er Mois", "Imposable 2&egrave;me Mois", "CNAPS TRAVAILLEUR 2&egrave;me Mois", "CNAPS EMPLOYEUR 2&egrave;me Mois","Imposable 3&egrave;me Mois", "CNAPS TRAVAILLEUR 3&egrave;me Mois", "CNAPS EMPLOYEUR 3&egrave;me Mois", "Cotisation du travailleur", "Cotisation de l'employeur","Ann&eacute;e"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String libelleRecap[] = {"","","Somme Cotisation travailleur", "Somme Cotisation employeur"};
    String lienTableau[] = {pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
    String colonneLien[] = {"idpersonnel"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String attributLien[] = {"id"};
    pr.getTableau().setAttLien(attributLien);
    String libRecap[] = {"", "Somme Cotisation travailler", "Somme Cotisation employeur"};
    pr.getTableauRecap().setLibeEntete(libelleRecap);

    pr.getFormu().setAnotherButton(
        "                <a id='export-btn' class='btn btn-secondary btn-small btn-bg-white' href='#' onclick='exportCnaps()'>\n" +
        "                    <i class='material-symbols-rounded'>download</i> Exporter\n" +
        "                </a>"
    );

    String[] etatVal = {"CNAPS_T1", "CNAPS_T2", "CNAPS_T3", "CNAPS_T4"};
    String[] etatAff = {"1er trimestre", "2eme trimestre", "3eme trimestre", "4eme trimestre"};
%>
<script>
    function changerDesignation() {
        document.personnel.submit();
    }

    function exportCnaps() {
        // Get the etat parameter value
        var etatValue = document.getElementById("etat").value;

        // Build export URL
        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=cnaps_affiche"
            + "&etat=" + encodeURIComponent(etatValue);

        // Update button href and trigger
        var exportButton = document.getElementById("export-btn");
        exportButton.href = exportUrl;
    }

    // Attach event listener
    document.getElementById("export-btn").addEventListener("click", exportCnaps);
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>CNAPS</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/cnaps/cnaps_affiche.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    Trimestre :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(etatVal[i].equalsIgnoreCase(dr.getNomTable())) {%>
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
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
           // String libEnteteAffiche[] = {"Matricule","Nom et pr&eacute;noms","Cnaps", "Embauche", "Debauche", "Mois 1","TP1", "Mois 2","TP2", "Mois 3","TP3", "Total declare","Total plafonne", "Cotisation travailleur", "Cotisation employeur"};
           // pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
