<app-details>
    <div id="introduction" class="col-md-12 animated slideInRight">
        <h5><span>Introduction</span></h5>
        <div id="introduction-text" class="text-block">
            <p id="text-intro">
                {introText}
            </p>
            <a id="download-button" href="" target="_blank"><button  class="btn btn-default btn-small"><p style="color:#2FACE0;margin-left:45px;">Download</p></button></a>
        </div>

    </div>
    <div id="author" class="col-md-12 animated slideInRight">
        <h5><span> About Author:</span></h5>
        <p id="text-team" class="team-details">
            {cohortName} </p>
        <div class="member-list row">
            <div class="member-block col-md-4 no-side-padding text-center" each="{members}">
                <img class="member-avatar" src="/img/unknown-user.png" />
                <p class="member-name">{name}</p>
            </div>
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