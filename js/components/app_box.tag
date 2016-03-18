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

           // Taken from http://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array-in-javascript
            var shuffle = function(a) {
                var j, x, i;
                for (i = a.length; i; i -= 1) {
                    j = Math.floor(Math.random() * i);
                    x = a[i - 1];
                    a[i - 1] = a[j];
                    a[j] = x;
                }
            };

            $.getJSON(this.getSearchUrl()).success(function(data) {
                var records = data.records;
                var apps = [];
                if (records.length == 0) {
                    window.location.href = '/'; // Redirect back to root if there are no results.
                }
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
                shuffle(apps);
                if (!self.items) {
                    setTimeout(function () {
                        self.showDemo(apps[0]);
                    }, 0);
                }
                self.update({items: apps});
            });
        };

        this.getSearchUrl = function() {
            if (location.hostname == 'localhost') {
                var url = './test.json?maxRecords=20';
            } else {
                // Reverse proxy to hide our API key from the world.
                var url = "/airtable/v0/appXISBe0Du86nEiX/Apps?maxRecords=20";
            }

            // Also taken from Stack Overflow somewhere.
            var getParams = function getParameterByName(name, url) {
                if (!url) url = window.location.href;
                name = name.replace(/[\[\]]/g, "\\$&");
                var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                        results = regex.exec(url);
                if (!results) return null;
                if (!results[2]) return '';
                return decodeURIComponent(results[2].replace(/\+/g, " "));
            };

            var cohortName = getParams('cohortName');
            if (cohortName) {
                return (url + '&filterByFormula=' + encodeURIComponent('cohortName="' + cohortName + '"'));
            }
            var collection = getParams('collection');
            if (collection) {
                return (url + '&filterByFormula=' + encodeURIComponent('FIND("' +
                    collection + '", CONCATENATE(collections)) > 0'));
            }


            return url;
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
