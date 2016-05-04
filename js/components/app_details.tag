<app-details>
    <div id="introduction" class="col-md-12 animated slideInRight">
        <h5><span>Description</span></h5>
        <div id="introduction-text" class="text-block">
            <p id="text-intro">
                {description}
            </p>
        </div>

    </div>
    <div id="author" class="col-md-12 animated slideInRight">
        <h5><span> About the Author:</span></h5>
        <p id="text-team" class="team-details">
            {cohortName} </p>
        <div class="member-list row">
            <member each="{members}"></member>
       </div>
    </div>

    <script>
        this.on('mount', function() {
            // XXX: There's also logic in style.css.
            // Eventually move this to css. I don't love slimscroll.
            $('#introduction-text').slimScroll({
                height: 199
            });
        });

        this.on('update', function() {
           $('#right-block').removeClass('animated slideInRight');
        });
        this.on('updated', function() {
            $('#right-block').addClass('animated slideInRight');
        });
    </script>

</app-details>

<member>
    <div class="member-block col-md-4 no-side-padding text-center">
        <img class="member-avatar" src="{thumbUrl}" />
        <p class="member-name">{name}</p>
    </div>

    <script>
        this.on('mount', function() {
            var self = this;
            if (location.hostname == 'localhost') {
              var url = '/chau.json';
            } else {
              // var url = '/airtable/v0/appXISBe0Du86nEiX/People/' + this.id;
              var url = "http://coderschoolv2-1.herokuapp.com/showcase/People/" + this.id;
            }
            $.getJSON(url).success(function(data) {
                var fields = data.fields;
                self.update({
                    name: fields.name,
                    thumbUrl: fields.media[0].thumbnails.large.url
                });
            });
        });
    </script>
</member>
