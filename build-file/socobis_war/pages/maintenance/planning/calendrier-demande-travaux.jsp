<%@ page import="maintenance.utils.*" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="maintenance.planning.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>

<style>
    .calendar-container {
        margin: 10px 20px;
        font-family: Arial, sans-serif;
        background: #fff;
        padding: 20px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.27);
        border-radius: 10px;
    }

    .calendar-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 15px 0px;
        border-radius: 10px;
    }

    .calendar-title {
        font-size: 22px;
        font-weight: bold;
        color: #333;
    }

    .nav-controls {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .nav-controls div {
        display: flex;
        gap: 0px;
    }

    .btn-groupes button {
        border: none;
        /* background: #f0f0f5; */
        color: #666;
        background-color: white;
        padding: 6px 10px;
        cursor: pointer;
        transition: background 0.2s;
        box-shadow: 0 0 0 0.5px rgb(143, 143, 143);
    }

    .btn-groupes a{
        background-color: transparent;!important;
        border: none;!important;
    }

    .btn-groupes button:hover {
        background: #e0e0eb;
    }

    .btn-groupes{
        display: flex;
        gap: 8px;
        background-color: white;
        overflow: hidden;
        border-radius: 2px;
        box-shadow: 0 0 0 0.5px rgb(143, 143, 143);
    }

    .view-modes {
        display: flex;
        gap: 0px;
    }

    /* .view-modes button {
      border: 1px solid #ddd;
      background: #fff;
      padding: 6px 14px;
      border-radius: 6px;
      cursor: pointer;
      transition: all 0.2s;
    } */

    .btn-groupes button.active {
        background: #9b79e8;
        color: #fff;
        border: 1px solid #7a57d1;
        font-weight: bold;
    }

    .calendar-grid {
        width: 100%;
        background-color: white;
        overflow: hidden;
        border-radius: 8px;
        border: 1px solid var(--Border);
    }

    .calendar-row {
        display: flex;
        width: 100%;
        gap: 1px;
    }
    .calendar-cell-title{
        width: calc(100% / 7);
        padding: 10px 2px;
        text-align: center;
        background-color: rgba(231, 231, 231, 0.334);
        box-shadow: 0 0 0 0.5px rgb(143, 143, 143);
    }
    .calendar-cell {
        width: calc(100% / 7);
        aspect-ratio: 1/0.6;
        box-shadow: 0 0 0 0.7px var(--Border);
        padding: 4px;
    }
    .calendar-cell-desactive {
        box-shadow: 0 0 0 0.7px var(--Border);
        width: calc(100% / 7);
        aspect-ratio: 1/0.6;
        padding: 5px 2px;
        background-color: var(--Background-tertiaire);
    }

    .event{
        font-size: 18px;
        display: flex;
        justify-content: space-between;
        gap: 2px;
        align-items: flex-start;
        line-height: 1.2;
        text-overflow: ellipsis;
        transition: all 0.3s ease;
        cursor: pointer;
        width: 100%;
        flex-direction: column;
        padding: 4px;
    }

    .event-title {
        border-left: 3px solid #0e66ff;
        padding: 2px 6px;
        margin: 4px 0;
        border-radius: 8px;
        overflow: hidden;
        width: 100%;
        font-size: 12px;
        display: flex;
        justify-content: space-between;
        flex-direction: column;
    }

    .event-hours{
        width: fit-content;
        padding: 2px 2px;
        font-size: 12px;
    }
    .day-number {
        font-weight: 600;
        font-size: 14px;
        color: #495057;
        margin-bottom: 8px;
        text-align: right;
    }

    .event-title:hover{
        box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
    }
    .today{
        color: var(--Primaire-blue-main-color);;
        font-weight: bold;
    }
    .event-title .event-title-text {
        font-weight: 600;
        max-height: 28px;
        text-overflow: ellipsis;
        overflow: hidden;
    }

    .calendar-cell-title {
        width: calc(100% / 7);
        padding: 8px 8px;
        background-color: white;
        text-align: start;
    }
    .calendar-cell-title {
        box-shadow: 0 0 0 0.7px var(--Border);
    }
    .event-title {
        margin: 2px;
    }
    .calendar-header {
        padding: 0px 0px 15px 0px;
    }
    .calendar-container {
        margin: 0;
    }
</style>

<%
    try{
        String lien = (String) session.getValue("lien");
        user.UserEJB u= (user.UserEJB) session.getValue("u");

        /* Récuperer la date par défaut */
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String dateEncours = request.getParameter("d");
        String todayDate = Utilitaire.dateDuJour();
        if (dateEncours == null || dateEncours.trim().isEmpty()) {
            LocalDate aujourdHui = LocalDate.now();
            dateEncours = aujourdHui.format(formatter);
        }

        String debutEtFinDeSemaine[]=CalendarUtil.getDebutEtFinDuMois(dateEncours);
        String mois = debutEtFinDeSemaine[0].substring(3, 5);
        String annee = debutEtFinDeSemaine[0].substring(6, 10);
        String idClient = null;
        CalendrierDemandeTravaux eta=new CalendrierDemandeTravaux ("","","","",debutEtFinDeSemaine[0],debutEtFinDeSemaine[1]);
        String[] listeDate=eta.getListeDate();
        List<LocalDate> dateAvants = CalendarUtil.getDatesAvantDansSemaine(LocalDate.parse(listeDate[0], formatter));
        List<String> trueDate = new ArrayList<>();
        for (LocalDate d : dateAvants) {
            trueDate.add(d.format(formatter));
        }
        trueDate.addAll(Arrays.asList(listeDate));
        listeDate = trueDate.toArray(new String[]{});
        String dateDuJour = Utilitaire.dateDuJour();
        // URL du site
        String urlComplete = request.getRequestURL().toString();
        String queryString = request.getQueryString();

        if (queryString != null) {
            urlComplete += "?" + queryString;
        }
        String lienPrecedent = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,debutEtFinDeSemaine[2]);
        String lienSuivant = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,debutEtFinDeSemaine[3]);
        String lienToday = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,todayDate);


        String temp="";
        temp=temp+ "<div class=\"modal fade\" id=\"linkModal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"linkModalLabel\" aria-hidden=\"true\">\r\n" +
                "  <div style='width:60%;background:transparent;' class=\"modal-dialog modal-dialog-centered\" role=\"dialog\">\r\n" + //
                "    <div style=\"border-radius: 16px;padding:15px;overflow-y:auto;height:80vh\" class=\"modal-content\">\r\n" + //
                "      <div class=\"modal-body\">\r\n"+
                "       <div id=\"modalContent\">\r\n>";
        temp +=                "</div>\r\n" + //
                "    </div>\r\n" + //
                "   </div>\r\n" + //
                "  </div>\r\n" + //
                "</div>";
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1> <i class="fa fa-calendar"></i>&nbsp;&nbsp;&nbsp;Planning de Travaux </h1>
    </section>
    <!-- Légende -->
    <%--    <div class="legend">--%>
    <%--        <span class="occupe">Cre&eacute;</span>--%>
    <%--        <span class="disponible">Valid&eacute;</span>--%>
    <%--    </div>--%>
    <section class="content">
        <div class="row m-0">
            <div class="calendar-container">
                <div class="calendar-header">
                    <div class="calendar-title"><%=CalendarUtil.getMonthName(Integer.parseInt(mois))%> <%=annee%></div>

                    <div class="d-flex gap-2">
                        <div class="d-flex gap-2">
                            <a href="<%=lienPrecedent%>" id="prev-week" class="btn btn-secondary">
                                <i class="fa fa-chevron-left"></i>
                            </a>
                            <a href="<%=lienSuivant%>" id="next-week" class="btn btn-secondary">
                                <i class="fa fa-chevron-right"></i>
                            </a>
                        </div>
                        <a href="<%=lienToday%>" id="next-week" class="btn btn-secondary">
                            Aujourd'hui
                        </a>
                    </div>

                    <%--                    <div class="view-modes">--%>
                    <%--                        <div class="btn-groupes">--%>
                    <%--                            <button class="active">Month</button>--%>
                    <%--                            <button>Week</button>--%>
                    <%--                            <button>Day</button>--%>
                    <%--                            <button>List</button>--%>
                    <%--                        </div>--%>
                    <%--                    </div>--%>
                </div>

                <div class="calendar-grid">
                    <div class="calendar-row">
                        <div class="calendar-cell-title">Lun.</div>
                        <div class="calendar-cell-title">Mar.</div>
                        <div class="calendar-cell-title">Mer.</div>
                        <div class="calendar-cell-title">Jeu.</div>
                        <div class="calendar-cell-title">Ven.</div>
                        <div class="calendar-cell-title">Sam.</div>
                        <div class="calendar-cell-title">Dim.</div>
                    </div>
                    <%
                        int startIndex = 0;
                        int endIndex = 7;
                        for (int i = 0; i < 5; i++) {
                    %>
                    <div class="calendar-row">
                        <% for (int j = startIndex; j <= endIndex; j++) {
                            if (j==endIndex){
                                startIndex = endIndex;
                                endIndex += 7;
                                break;
                            }
                        %>
                        <% if (j<listeDate.length){
                            DemandeTravauxCpl[] reservations = eta.getByDate(listeDate[j]);
                            String dayNumber = listeDate[j].split("/")[0];
                            String classDay = "";
                            if (listeDate[j].equals(dateDuJour)){
                                classDay = "today";
                            }
                            String styleCalendarCell = "";
                            if(!listeDate[j].split("/")[1].equals(mois)){
                                styleCalendarCell = "style=\"background-color: var(--Background-secondaire);\"";
                            }
                        %>
                        <% if(reservations!=null) {%>
                        <div class="calendar-cell" <%=styleCalendarCell%> >
                            <div class="day-number <%=classDay%>"><%=dayNumber%></div>
                            <% for (int k = 0; k < 3 && k<reservations.length; k++) {%>
                            <div onclick="ouvrirModal(event,'moduleLeger.jsp?but=maintenance/demandetravaux/demandetravaux-fiche.jsp&id=<%=reservations[k].getId()%>','modalContent')" class="event">
                                <div class="event-title" style="<%=eta.getCodeCouleur(reservations[k])%>">
                                    <span class="event-title-text">
                                        <%=reservations[k].getDescription()%>
                                    </span>
                                    <div class="event-hours"><%=reservations[k].getPriorite()%></div>
                                </div>
                            </div>
                            <% } %>
                            <% if (reservations.length>3){%>
                            <button onclick="ouvrirModal(event,'moduleLeger.jsp?but=maintenance/planning/inc/demande-travaux-details.jsp&daty=<%=listeDate[j]%>','modalContent')" class="btn btn-tertiary w-100 btn-small" >+<%=reservations.length-3%> de plus</button>
                            <%}%>
                        </div>
                        <% } else {%>
                        <div class="calendar-cell-desactive">

                        </div>
                        <% } %>
                        <% } else { %>
                        <div class="calendar-cell-desactive">

                        </div>
                        <% } %>

                        <% } %>
                    </div>
                    <% } %>
                </div>

            </div>
        </div>
    </section>
</div>

<% out.println(temp);%>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>

