import { LightningElement, wire } from 'lwc';
import getStats from '@salesforce/apex/DashboardController.getApplicationStats';

export default class JobDashboard extends LightningElement {

    total = 0;
    rejected = 0;
    applied = 0;

    @wire(getStats)
    wiredStats({ data, error }) {
        if (data) {
            this.total = data.total;
            this.rejected = data.rejected;
            this.applied = data.applied;
        } else if (error) {
            console.error(error);
        }
    }
}