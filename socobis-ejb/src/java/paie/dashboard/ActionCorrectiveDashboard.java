package paie.dashboard;

import bean.ClassMAPTable;

public class ActionCorrectiveDashboard extends ClassMAPTable {
    private String id;
    private int actionsrealisees;
    private int actionsnonrealisees;

    public ActionCorrectiveDashboard() throws Exception {
        this.setNomTable("V_DASHBOARD_ACTION_CORRECTIVE");
    }

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public int getActionsrealisees() {
        return actionsrealisees;
    }
    public void setActionsrealisees(int actionsrealisees) {
        this.actionsrealisees = actionsrealisees;
    }

    public int getActionsnonrealisees() {
        return actionsnonrealisees;
    }
    public void setActionsnonrealisees(int actionsnonrealisees) {
        this.actionsnonrealisees = actionsnonrealisees;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
}