import { LightningElement, track } from 'lwc';
import getOpenPositions from '@salesforce/apex/PositionController.getOpenPositions';
import getAllPositions from '@salesforce/apex/PositionController.getAllPositions';

export default class PositionList extends LightningElement {

    @track positions = [];
    @track isLoading = true;
    @track hasError = false;
    @track showOnlyOpen = true;

    openCount = 0;
    closedCount = 0;
    totalPositions = 0;

    connectedCallback() {
        this.loadPositions();
    }

    showOpenOnly() {
        this.showOnlyOpen = true;
        this.loadPositions();
    }

    showAll() {
        this.showOnlyOpen = false;
        this.loadPositions();
    }

    get openBtnVariant()  { return this.showOnlyOpen ? 'brand' : 'neutral'; }
    get allBtnVariant()   { return !this.showOnlyOpen ? 'brand' : 'neutral'; }
    get hasPositions()    { return this.positions && this.positions.length > 0; }

    loadPositions() {
        this.isLoading = true;
        this.hasError  = false;

        const apexCall = this.showOnlyOpen ? getOpenPositions({}) : getAllPositions({});

        apexCall
            .then(data => {
                this.positions = data.map(pos => ({
                    ...pos,
                    recordUrl:     '/lightning/r/Position__c/' + pos.Id + '/view',
                    payRange:      this.formatPayRange(pos.Min_Pay__c, pos.Max_Pay__c),
                    departmentLabel: pos.Functional_Area__c || 'N/A',
                    cardClass:     pos.Position_Status__c === 'Open' ? 'pos-card open-card' : 'pos-card closed-card',
                    statusBadge:   pos.Position_Status__c === 'Open' ? 'status-badge open-badge' : 'status-badge closed-badge'
                }));

                this.totalPositions = data.length;
                this.openCount   = data.filter(p => p.Position_Status__c === 'Open').length;
                this.closedCount = data.filter(p => p.Position_Status__c === 'Closed').length;

                this.isLoading = false;
            })
            .catch(() => {
                this.hasError  = true;
                this.isLoading = false;
            });
    }

    formatPayRange(min, max) {
        if (min && max) return `$${min.toLocaleString()} – $${max.toLocaleString()}`;
        if (min)        return `From $${min.toLocaleString()}`;
        if (max)        return `Up to $${max.toLocaleString()}`;
        return 'Salary not specified';
    }
}
