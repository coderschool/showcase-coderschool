<app-box>
    <div id="app-box" class="app-box ">
        <app-icon each="{ items }"></app-icon>
    </div>

    <script>

        this.onAppIconClick = function(e) {
            this.showDemo(e.item);
        };

        this.showDemo = function(app) {
           this.gifImage.attr('src', app.gifUrl);

            opts.appDetails.update({
                description: app.description,
                members: app.members,
                cohortName: app.cohortName
            });
        };

        this.fetchAndUpdate = function() {
            var self = this;
            // Reverse proxy to hide our API key from the world.
            var url = "/airtable/v0/appXISBe0Du86nEiX/Apps?maxRecords=10";
//            var url = './test.json';
            $.getJSON(url).success(function(data) {
                var records = data.records;
                var apps = [];
                for(var i=0; i < records.length; i++) {
                    var fieldsData = records[i].fields;
                    var members = [];
                    for(var j=0; j<fieldsData.members.length; j++) {
                        members.push({ id: fieldsData.members[j] });
                    }
                    apps.push({
                        name: fieldsData.name,
                        appIconUrl: fieldsData.appIcon[0].url,
                        description: fieldsData.description,
                        gifUrl: fieldsData.media[0].url,
                        cohortName: fieldsData.cohortName,
                        members: members
                    });
                }
                if(!self.items) {
                    setTimeout(function () {
                        self.showDemo(apps[0]);
                    }, 0);
                }
                self.update({items: apps});
            });
        };

        this.on('mount', function() {
            this.fetchAndUpdate();
            // XXX: There's also logic in style.css.
            // Eventually move this to css. I don't love slimscroll.
            $('#app-box').slimScroll({
                height: 229
            });
            this.gifImage = $('#gif-image').find('img');
        });

        this.on('update', function() {
            if(this.gifImage) {
                this.gifImage.removeClass('animated zoomIn');
            }
        });

        this.on('updated', function() {
            if(this.gifImage) {
                this.gifImage.addClass('animated zoomIn');
            }
        });

    </script>

</app-box>


<app-icon>
    <div class="col-md-4 app-icon text-center">
        <div class="img">
            <img src="{appIconUrl}">
            <div class="overlay">
                <a id="teachme" onclick="{ onAppIconClick }" class="expand">></a>
                <a class="close-overlay hidden">x</a>
            </div>
        </div>

        <h6>{ name }</h6>
    </div>

    <style scoped>
       :scope {cursor: pointer;}
    </style>
</app-icon>