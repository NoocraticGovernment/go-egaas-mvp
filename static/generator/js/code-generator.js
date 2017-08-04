var CodeGenerator = {};

CodeGenerator.Controller = JS_CLASS({
    constructor: function (param) {
        CP(this, param);

        this.model = new CodeGenerator.Model();

        this.$over = this.$containerWrapper.find(".js-over");
        this.$overInner = this.$over.find(".b-over__inner");
        //$(document.body).append(this.$over);
        this.$over.hide();

        this.$bag = this.$containerWrapper.find(".js-draggable-bag");
        this.$bagInner = this.$bag.find(".js-draggable-bag__inner");

        this.events();
    },

    setJsonData: function (json) {
        this.model.setJsonData(json);
    },

    generateCode: function () {
        var code = (new MainTemplate(this.model.json)).renderCode();
        this.$codeGenerated.html(code);
    },

    generateHTML: function () {
        return (new MainTemplate(this.model.json)).renderHTML();
    },

    printJSON: function () {
        this.$output.html(JSON.stringify(this.model.json));
    },

    createDraggableBag: function (html) {
        //this.$bag = $('<div class="b-draggable-bag"><div class="b-draggable-bag__inner">'+html+'</div></div>');
        //this.$bag.hide();
        //$(document.body).append(this.$bag);
        this.$bagInner.html(html);

    },

    removeDraggableBag: function () {
        if(this.$bag)
            this.$bag.hide();
    },

    moveDraggableBag: function (x, y) {
        this.$bag
            .show()
            .css("top", y + 3 - $(window).scrollTop())
            .css("left", x + 3 - $(window).scrollLeft());
    },

    events: function () {
        var self = this;

        this.recalcContainerOffset();

        this.$containerWrapper
            .on("mousemove", function (e) {

                if(self.findOverTagTimer) {
                    return;
                }

                self.findOverTagTimer = setTimeout((function() {
                    self.findOverTagTimer = null;
                }).bind(self), 100);

                self.overTag = self.findOverTag(
                    e.pageX - self.containerOffset.left,
                    e.pageY - self.containerOffset.top
                );


                if(!self.overTag)
                    self.overTag = {
                        "type": "Template",
                        "coords": {
                            "left": 0,
                            "top": 0,
                            "width": "100%",
                            "height": "100%"
                        }
                    };

                console.log("overTag", self.overTag);
                console.log("parentOverTag", self.parentOverTag);

                if(self.dragging) {

                    if(self.overTag) {

                        //если пытаемся положить внутрь перетаскиваемого тега, не пускаем
                        if (self.$container.find("*[tag-id=" + self.overTag.id + "]").closest(".b-draggable_dragging").length)
                            return;

                        self.$over
                            .removeClass("b-droppable_inside")
                            .removeClass("b-droppable_before")
                            .removeClass("b-droppable_after");

                        if (self.overPosition == "inside" && self.overTag.type != "Template") {
                            var tag = constructTag(self.overTag);
                            if (!tag.accept(self.draggingTag.name))
                                self.overPosition = "after";
                            //console.log("tag", tag);
                        }

                        //в основной контейнер - только внутрь
                        if (self.overTag.type == "Template") {
                            self.overPosition = "inside";
                            var tag = constructTag(self.overTag);
                            if (!tag.accept(self.draggingTag.name))
                                return;
                        }

                        if (self.overPosition == "before" || self.overPosition == "after") {
                            //before/after - проверка accept parent
                            if (self.parentOverTag) {
                                var parentTag = constructTag(self.parentOverTag);
                                if (!parentTag   //в самый высокий уровень можно только класть внутрь, а не до/после
                                    || !parentTag.accept(self.draggingTag.name)) {
                                    return;
                                }

                            }
                        }

                        self.$over
                            .show()
                            .css("left", self.overTag.coords.left)
                            .css("top", self.overTag.coords.top)
                            .css("width", self.overTag.coords.width)
                            .css("height", self.overTag.coords.height)
                            .addClass("b-droppable_" + self.overPosition);
                    }
                }
                else {
                    if(self.overTag) {
                        self.$over
                            .show()
                            .css("left", self.overTag.coords.left)
                            .css("top", self.overTag.coords.top)
                            .css("width", self.overTag.coords.width)
                            .css("height", self.overTag.coords.height);
                    }
                }

            })
            .on("mouseleave", function () {
                self.$over.hide();
            });

        this.$over
            .on("mousedown", function () {
                if(self.overTag && self.overTag.type == "tag") {
                    self.draggingTag = self.overTag;
                    self.$draggingTag = self.$container.find("*[tag-id=" + self.overTag.id + "]");
                    //console.log("self.$draggingTag", self.$draggingTag);
                    if(self.$draggingTag && self.$draggingTag.length) {
                        self.startDragging();

                    }
                }
            })
            .on("mouseup", function () {
                self.cancelDragging();
                self.dropTo(self.overTag);
            });

        $(document.body)
            .off("mouseup", function(e) {
                self.onBodyMouseUp(e);
            })
            .on("mouseup", function (e) {
                self.onBodyMouseUp(e);
            })
            .off("mouseleave", function(e) {
                self.onBodyMouseLeave(e);
            })
            .on("mouseleave", function (e) {
                self.onBodyMouseLeave(e);
            })
            .off("mousemove", function(e) {
                self.onBodyMouseMove(e)
            })
            .on("mousemove",  function(e) {
                self.onBodyMouseMove(e)
            });




        // $(".b-over").on("mouseout", function () {
        //     $(this).hide();
        // });

        $(".js-draggable")
            .off("dragstart")
            .on("dragstart", function (e) {
                e.preventDefault();
            })
            .off("mousedown")
            .on("mousedown", function (e) {
                e.stopPropagation();
                self.$draggingTag = $(this);
                self.draggingTag = {
                    "type": "tag",
                    "name": $(this).attr("tag-name"),
                    "body": []
                };

                if($(this).attr("tag-params")) {
                    self.draggingTag.params = JSON.parse($(this).attr("tag-params"));
                }
                if($(this).attr("tag-nestedClassList")) {
                    self.draggingTag.nestedClassList = JSON.parse($(this).attr("tag-nestedClassList"));
                }
                //ol, liClass

                self.startDragging();
            });

    },

    onBodyMouseMove: function (e) {
        if(!this.dragging)
            return;
        this.moveDraggableBag(e.pageX, e.pageY);
    },

    onBodyMouseUp: function (e) {
        if(!this.dragging)
            return;
        this.cancelDragging();
    },

    onBodyMouseLeave: function () {
        this.cancelDragging();
    },

    startDragging: function () {
        this.dragging = true;
        //this.$overInner.addClass("g-move");
        $(document.body)
            .addClass("g-no-select")
            .addClass("g-no-overflow-x");
        this.createDraggableBag(this.$draggingTag.get(0).outerHTML);
        this.$draggingTag.addClass("b-draggable_dragging");
    },

    cancelDragging: function () {
        this.dragging = false;
        //this.$overInner.removeClass("g-move");
        this.$over
            .removeClass("b-droppable_inside")
            .removeClass("b-droppable_before")
            .removeClass("b-droppable_after");
        $(document.body)
            .removeClass("g-no-select")
            .removeClass("g-no-overflow-x");
        this.removeDraggableBag();


        $(".b-draggable_dragging").removeClass("b-draggable_dragging");
    },

    dropTo: function (overTag) {
        //self.$draggingTag = $("*[tag-id=" + self.overTag.id + "]");
        console.log("dropTo", overTag, this.overPosition, "what", this.draggingTag);
        //if(this.overPosition == "inside") {
        //    this.json
        //}

        this.model.appendToTree(this.draggingTag, overTag, this.overPosition);

        this.generateCode();
        this.render();


    },

    setHTML: function (html) {
        this.html = html;
    },

    render: function () {
        var self = this;
        this.$container.html(this.generateHTML());
        //alert("rendered");
        this.recalcTagsCoords();
    },

    recalcContainerOffset: function () {
        this.containerOffset = this.$container.offset();
    },

    recalcTagsCoords: function () {
        var self = this;
        var $imgs = this.$container.find("img");
        var loadCounter = 0;
        if($imgs.length == 0)
            this.calcTagsCoords();
        this.$container.find("img").each(function() {
            $(this).on("load error", function () {
                loadCounter++;
                if(loadCounter >= $imgs.length)
                    self.calcTagsCoords();
            });
        });
    },

    calcTagsCoords: function () {
        this.recalcContainerOffset();
        console.log("cont offset", this.containerOffset.top, this.containerOffset.left);
        this.calcTagCoords(this.model.json);
    },

    calcTagCoords: function (tag) {
        if(tag.id) {
            var $tag = this.$container.find('*[tag-id="'+tag.id+'"]');
            var offset = $tag.offset();
            //console.log(tag.name + " offset", '*[tag-id="'+tag.id+'"]', $tag, offset);
            tag.coords = {
                left: offset.left - this.containerOffset.left,
                top: offset.top - this.containerOffset.top,
                width: $tag.outerWidth(),
                height: $tag.outerHeight()
            };
        }
        if(tag.body) {
            for (var i = 0; i < tag.body.length; i++) {
                this.calcTagCoords(tag.body[i]);
            }
        }
    },

    findOverTag: function (x, y) {
        this.overTag = null;
        this.parentOverTag = null;
        this.tmpParentOverTag = null;

        this.overPosition = "inside";
        this.findNextOverTag(x, y, this.model.json);
        return this.overTag;
    },
    findNextOverTag: function (x, y, tag) {
        if(tag) {
            if (tag.id && tag.coords) {
                if (x >= tag.coords.left && x <= tag.coords.left + tag.coords.width
                    && y >= tag.coords.top && y <= tag.coords.top + tag.coords.height) {

                    if (!this.overTag || tag.coords.width < this.overTag.coords.width || tag.coords.height < this.overTag.coords.height) {
                        this.overTag = tag;
                        this.parentOverTag = this.tmpParentOverTag;

                        this.overPosition = "inside";

                        if (x < tag.coords.left + tag.coords.width * 0.33
                            && y < tag.coords.top + tag.coords.height * 0.33) {
                            this.overPosition = "before";
                        }

                        if (x > tag.coords.left + tag.coords.width * (1 - 0.33)
                            && y > tag.coords.top + tag.coords.height * (1 - 0.33)) {
                            this.overPosition = "after";
                        }
                    }
                }
            }
            if (tag.body) {
                for (var i = 0; i < tag.body.length; i++) {
                    this.tmpParentOverTag = tag;
                    this.findNextOverTag(x, y, tag.body[i]);
                }
            }
        }
    }
});

CodeGenerator.Model = JS_CLASS({
    constructor: function (param) {
        this.json = null;
        CP(this, param);
    },

    setJsonData: function (json) {
        this.json = json;
    },

    appendToTree: function (tag, toTag, position) {
        var move = false;
        var inserted = false;
        if(toTag) {

            if(tag.id) {
                console.log("move");
                move = true;
            }
            else {
                console.log("new");
                move = false;
                tag.id = this.generateId()
            }

            if(move) {
                //удаляем из предыдущего пложения
                this.findElementById(this.json, tag.id);
                console.log("remove from prev pos", this.findInfo);

                if (this.findInfo.el && this.findInfo.parent) {
                    this.findInfo.parent.body.splice(this.findInfo.parentPosition, 1);
                    console.log("this.findInfo.parent.body.splice(" + this.findInfo.parentPosition + ", 1)");
                    console.log("parent: ", this.findInfo.parent);
                }
            }


            this.findElementById(this.json, toTag.id);
            if (this.findInfo.el) {
                console.log("appendToTree found", this.findInfo);
                if(position == "inside") {
                    this.findInfo.el.body.push(tag);
                    //inserted = true;
                }
                if(position == "before") {
                    var newPosition = this.findInfo.parentPosition - 1;
                    if(newPosition < 0)
                        newPosition = 0;
                    this.findInfo.parent.body.splice(newPosition, 0, tag);
                    //inserted = true;
                }
                if(position == "after") {
                    var newPosition = this.findInfo.parentPosition + 1;
                    this.findInfo.parent.body.splice(newPosition, 0, tag);
                    //inserted = true;
                }
            }


        }
    },

    findElementById: function (el, id) {
        this.findInfo = {
            el: null,
            parent: null,
            parentPosition: 0
        };
        this.findNextElementById(el, id);
    },

    findNextElementById: function (el, id) {
        //console.log("findNextElementById", el, id);

        if (el.id == id) {
            this.findInfo.el = el;
            return;
        }
        if (el.body) {

            for (var i = 0; i < el.body.length; i++) {
                if(this.findInfo.el)
                    break;
                this.findInfo.parent = el;
                this.findInfo.parentPosition = i;
                this.findNextElementById(el.body[i], id);
            }
        }
    },

    generateId: function() {
        return "tag_" + (10000000 + Math.floor(Math.random() * 89999999));
    }
});


function constructTag(item, offset) {
    var tagObj = null;
    if(item.type == "Template") {
        tagObj = new MainTemplate(item, offset);
    }
    switch(item.name) {
        case "A":
            tagObj = new TagA(item, offset);
            break;
        case "P":
            tagObj = new TagP(item, offset);
            break;
        case "Div":
            tagObj = new TagDiv(item, offset);
            break;
        case "Image":
            tagObj = new TagImage(item, offset);
            break;
        case "Li":
            tagObj = new TagLi(item, offset);
            break;
        case "Divs":
            tagObj = new TagDivs(item, offset);
            break;
        case "UList":
            tagObj = new TagUList(item, offset);
            break;
        case "LiBegin":
            tagObj = new TagLiBegin(item, offset);
            break;
    }
    return tagObj;
}

var Tag = JS_CLASS({
    acceptRule: null,
    exceptRule: null,
    constructor: function (param) {
        CP(this, param);
    },
    renderOffset: function () {
        if(this.lineOffset)
            return Array((this.lineOffset) * 2).join(" ");
        return "";
    },
    renderHTML: function () {
        return "";
    },
    accept: function (tagName) {

        if(this.exceptRule) {
            var exceptRuleArr = this.exceptRule.split(" ");
            if ($.inArray(tagName, exceptRuleArr) > -1)
                return false;
        }

        if(!this.acceptRule)
            return false;
        if(this.acceptRule == "*")
            return true;
        var acceptRuleArr = this.acceptRule.split(" ");
        return ($.inArray(tagName, acceptRuleArr) > -1);
    }
});

/*простые теги, например a, p, img*/
var SimpleTag = JS_CLASS(Tag, {
    params: {},
    name: "",
    lineOffset: 0,
    acceptRule: null,
    constructor: function (param, lineOffset) {
        CP(this, param);
        if(lineOffset)
            this.lineOffset = lineOffset;
        console.log("construct " + this.name, this.lineOffset);
    },
    renderCode: function () {

        var code = this.renderOffset() + this.name + "{";
        var paramArr = [];
        for(var paramName in this.params) {
            if (this.params.hasOwnProperty(paramName)) {
                paramArr.push(paramName + ' = "' + this.params[paramName] + '"');
            }
        }
        code += paramArr.join(", ");
        code += "}\n";
        return code;
    }
});

/* теги со вложенностью, например LiBegin, UList*/
var StructureTag = JS_CLASS(Tag, {
    params: {},
    nameBegin: "",
    nameEnd: "",
    lineOffset: 0,
    acceptRule: "*",
    exceptRule: "Li LiBegin",
    constructor: function (param, lineOffset) {
        CP(this, param);
        if(lineOffset)
            this.lineOffset = lineOffset;
    },
    renderCode: function () {
        var code = this.renderOffset() + this.nameBegin + "{";
        var paramArr = [];
        for(var paramName in this.params) {
            if (this.params.hasOwnProperty(paramName)) {
                paramArr.push(paramName + ' = "' + this.params[paramName] + '"');
            }
        }
        code += paramArr.join(", ");
        code += "}\n";

        code += this.renderSubItems();

        code += this.renderOffset() + this.nameEnd + ":\n";
        return code;
    },

    renderSubItems: function (returnType) {
        var code = "";
        if(this.body) {
            for(var i = 0; i < this.body.length; i++) {
                var item = this.body[i];

                var tagObj = constructTag(item, this.lineOffset + 1);

                if(tagObj) {
                    if(returnType == 'html') {
                        code += tagObj.renderHTML();
                    }
                    else {
                        code += tagObj.renderCode();
                    }
                }
            }
        }
        return code;
    }

});


var MainTemplate = JS_CLASS(StructureTag, {
    nameBegin: "",
    nameEnd: "",
    renderCode: function () {
        return this.renderSubItems();
    },

    renderHTML: function () {
        return this.renderSubItems('html');
    }

});

var TagDivs = JS_CLASS(StructureTag, {
    nameBegin: "Divs",
    nameEnd: "DivsEnd",
    renderCode: function () {
        var code = this.renderOffset() + this.nameBegin + "(";

        code += this.nestedClassList.join(", ");
        code += ")\n";

        code += this.renderSubItems();

        code += this.renderOffset() + this.nameEnd + ":\n";
        return code;
    },

    renderHTML: function () {
        var html = '';

        for(var i = 0; i < this.nestedClassList.length; i++) {
            html += '<div tag-id="' + this.id + '" class="'+ this.nestedClassList[i] +'">';
        }

        html += this.renderSubItems('html');

        for(i = 0; i < this.nestedClassList.length; i++) {
            html += '</div>';
        }

        return html;
    }
});

var TagUList = JS_CLASS(StructureTag, {
    nameBegin: "UList",
    nameEnd: "UListEnd",
    acceptRule: "Li LiBegin",
    exceptRule: null,
    renderHTML: function () {
        var tag = 'ul';
        if(this.params.ol == 'ol')
            tag = 'ol';
        var html = '<' + tag + ' tag-id="' + this.id + '" class="' + (this.params.class ? this.params.class : "") + '">';

        html += this.renderSubItems('html');

        html += '</' + tag + '>';

        return html;
    }
});

var TagLiBegin = JS_CLASS(StructureTag, {
    nameBegin: "LiBegin",
    nameEnd: "LiEnd",

    renderHTML: function () {
        var html = '<li tag-id="' + this.id + '" class="' + (this.params.class ? this.params.class : "") + '">';

        html += this.renderSubItems('html');

        html += '</li>';
        return html;
    }
});

var TagA = JS_CLASS(SimpleTag, {
    name: "A",

    renderHTML: function () {
        var html = '<a tag-id="' + this.id + '" href="' + this.params.href + '" class="' + (this.params.class ? this.params.class : "") + '">' + this.params.text + '</a>';
        return html;
    }
});

var TagP = JS_CLASS(SimpleTag, {
    name: "P",

    renderHTML: function () {
        var html = '<p tag-id="' + this.id + '" class="' + (this.params.class ? this.params.class : "") + '">' + this.params.text + '</p>';
        return html;
    }
});

var TagDiv = JS_CLASS(SimpleTag, {
    name: "Div",
    renderHTML: function () {
        var html = '<div tag-id="' + this.id + '" class="' + (this.params.class ? this.params.class : "") + '">' + this.params.text + '</div>';
        return html;
    }
});

var TagImage = JS_CLASS(SimpleTag, {
    name: "Image",
    renderHTML: function () {
        var html = '<img tag-id="' + this.id + '" src="' + (this.params.src ? this.params.src : "") + '" class="' + (this.params.class ? this.params.class : "") + '" alt="' + (this.params.alt ? this.params.alt : "") + '">';
        return html;
    }
});

var TagLi = JS_CLASS(SimpleTag, {
    name: "Li",
    renderHTML: function () {
        var html = '<li tag-id="' + this.id + '" class="' + (this.params.class ? this.params.class : "") + '">' + this.params.text + '</li>';
        return html;
    }
});
