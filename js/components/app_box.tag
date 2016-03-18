<app-box>
    <div id="app-box" class="app-box ">
        <app-icon each="{ items }"></app-icon>
    </div>

    <script>

        this.onAppIconClick = function(e) {
            this.showDemo(e.item);
        };

        this.showDemo = function(app) {
            this.videoTag.empty();
            this.videoTag.hide();
            var gfycatBaseUrl = 'https://gfycat.com/cajax/get/';
            var self = this;
            $.getJSON(gfycatBaseUrl + app.gfycatName).success(function(data) {
                var item = data.gfyItem;
                if (item) {
                    self.videoTag.attr('width', '100%');
                    self.videoTag.attr('poster', item.mobilePosterUrl);
                    self.videoTag.attr('autoplay', '');
                    self.videoTag.attr('loop', '');
                    self.videoTag.attr('controls', '');
                    self.videoTag.append('<source type="video/mp4" src="' + item.mobileUrl + '"/>');
                    self.videoTag.append('<source type="video/webm" src="' + item.webmUrl + '"/>');
                    self.videoTag[0].load();
                    self.videoTag.one('loadeddata', function() {
                        self.videoTag.show();
                    });
                }
            });

            opts.appDetails.update({
                description: app.description,
                members: app.members,
                cohortName: app.cohortName
            });
        };

        this.fetchAndUpdate = function() {
            var self = this;

            if (location.hostname == 'localhost') {
              var url = '/test.json';
            } else {
              // Reverse proxy to hide our API key from the world.
              var url = "/airtable/v0/appXISBe0Du86nEiX/Apps?maxRecords=10";
            }
            $.getJSON(url).success(function(data) {
                var records = data.records;
                var apps = [];
                for (var i=0; i < records.length; i++) {
                    var fieldsData = records[i].fields;
                    var members = [];
                    for (var j=0; j<fieldsData.members.length; j++) {
                        members.push({ id: fieldsData.members[j] });
                    }
                    var appIconUrl = 'img/app-icon.png';
                    if (fieldsData.appIcon && fieldsData.appIcon.length > 0) {
                        appIconUrl = fieldsData.appIcon[0].url;
                    }
                    apps.push({
                        name: fieldsData.name,
                        appIconUrl: appIconUrl,
                        description: fieldsData.description,
                        gfycatName: fieldsData.gfycatName,
                        cohortName: fieldsData.cohortName,
                        members: members
                    });
                }
                if (!self.items) {
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
            this.videoTag = $('#gif-image').find('video');
        });

        this.on('update', function() {
            if (this.videoTag) {
                this.videoTag.removeClass('animated zoomIn');
            }
        });

        this.on('updated', function() {
            if (this.videoTag) {
                this.videoTag.addClass('animated zoomIn');
            }
        });

    </script>

</app-box>


<app-icon>
    <div class="col-md-4 app-icon text-center">
        <div class="img">
            <div class="overlay">
                <a onclick="{ onAppIconClick }" class="expand">></a>
                <a class="close-overlay hidden">x</a>
            </div>
            <img src="{appIconUrl}"/>
        </div>

        <h6>{ name }</h6>
    </div>

    <style scoped>
       :scope {cursor: pointer;}
        img {width: 58px;}
    </style>
</app-icon>
