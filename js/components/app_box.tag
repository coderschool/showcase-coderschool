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
                introText: app.introText,
                members: app.members,
                cohortName: app.cohortName
            });
        };

        this.fetchAndUpdate = function() {
            var self = this;
            $.getJSON('./test.json').success(function(data) {
                if(!self.items) {
                    setTimeout(function () {
                        self.showDemo(data.apps[0]);
                    }, 0);
                }
                self.update({items: data.apps});
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
            <img src="../img/app-icon-teachme.png">
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
