import { LightningElement, wire, track } from 'lwc';
import getAllApplications from '@salesforce/apex/JobApplicationController.getAllApplications';
import getApplicationsByStatus from '@salesforce/apex/JobApplicationController.getApplicationsByStatus';

export default class JobApplicationList extends LightningElement {

    @track applications = [];
    @track selectedStatus = 'All';
    @track isLoading = true;
    @track hasError = false;

    totalCount = 0;
    appliedCount = 0;
    interviewCount = 0;
    rejectedCount = 0;

    statusOptions = [
        { label: 'All', value: 'All' },
        { label: 'Applied', value: 'Applied' },
        { label: 'Schedule Interview', value: 'Schedule Interview' },
        { label: 'Rejected', value: 'Rejected' }
    ];

    connectedCallback() {
        this.loadApplications();
    }

    handleStatusChange(event) {
        this.selectedStatus = event.detail.value;
        this.loadApplications();
    }

    loadApplications() {
        this.isLoading = true;
        this.hasError = false;

        const apexMethod =
            this.selectedStatus === 'All'
                ? getAllApplications({})
                : getApplicationsByStatus({ status: this.selectedStatus });

        apexMethod
            .then(data => {
                this.applications = data.map(app => ({
                    ...app,
                    positionName: app.Position__r ? app.Position__r.Name : '—',
                    recordUrl: '/lightning/r/Job_Application__c/' + app.Id + '/view',
                    statusClass: this.getStatusClass(app.Status__c)
                }));

                this.totalCount     = this.applications.length;
                this.appliedCount   = this.applications.filter(a => a.Status__c === 'Applied').length;
                this.interviewCount = this.applications.filter(a => a.Status__c === 'Schedule Interview').length;
                this.rejectedCount  = this.applications.filter(a => a.Status__c === 'Rejected').length;

                this.isLoading = false;
            })
            .catch(() => {
                this.hasError = true;
                this.isLoading = false;
            });
    }

    getStatusClass(status) {
        if (status === 'Applied')             return 'badge badge-applied';
        if (status === 'Rejected')            return 'badge badge-rejected';
        if (status === 'Schedule Interview')  return 'badge badge-interview';
        return 'badge';
    }

    get hasApplications() {
        return this.applications && this.applications.length > 0;
    }
}
