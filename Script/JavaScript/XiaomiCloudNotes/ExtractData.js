(async () => {
    /**
     * Replaces :attribute: with the corresponding attribute and converts :: to :.
     * 
     * @param string The string pending to be proceeded.
     * @param attributes The attributes pending to be replaced with.
     */
    function substitute(string, attributes = {}) {
        let output = '';
        let insideColon = false;
        let attribute = '';
        for (let character of string) {
            if(character === ':') {
                insideColon = !insideColon;
                if(!insideColon)
                    output += attributes?.[attribute] ?? ( //If you set attributes[''] to something, it will replace the colon.
                        attribute.length ? `:${attribute}:` : ':'
                    );
                attribute = '';
                continue;
            }
            if(insideColon)
                attribute += character;
            else
                output += character;
        }
        return output;
    }

    /**
     * Fetches an image as data URL.
     * Reference: https://www.cnblogs.com/cyfeng/p/16107747.html
     * 
     * @param id The image ID.
     */
    async function fetchImage(id) {
        let image;

        {
            const exceptions = [];
            for(let i = 0; i < maxAttempts; i++) {
                try {
                    image = new Image();
                    /**
                     * Tainted canvases may not be exported.
                     * See https://www.cnblogs.com/iroading/p/11011268.html.
                     */
                    image.setAttribute('crossOrigin', 'anonymous');
                    image.src = substitute(urls['image'], { id });
                    await new Promise((resolve, reject) => {
                        image.addEventListener('load', resolve);
                        image.addEventListener('error', reject);
                    });
                    break;
                } catch(exception) {
                    exceptions.push(exception);
                }
            }
            if(exceptions.length) { //Remember !![] === true.
                window.failures ? window.failures.push(...exceptions) : window.failures = exceptions;
                throw new Error('Too many failed trials. For more information, check out window.failures.');
            }
        }

        const canvas = document.createElement('canvas');
        const { width, height } = image;
        canvas.width = width;
        canvas.height = height;
        canvas.getContext('2d').drawImage(image, 0, 0, width, height);
        return canvas.toDataURL('image/png');
    }
    
    /**
     * Requests a page and returns the result in JSON.
     * If failed, the request will be retried for `maxAttempts` time(s).
     * 
     * @param key The key of the URL in the var `urls`.
     * @param attributes Attributes.
     */
    async function query(key, attributes = {}) {
        const exceptions = [];
        for(let i = 0; i < maxAttempts; i++) {
            try {
                return await (await fetch(substitute(urls[key], {
                    time: (new Date()).getTime(),
                    ...attributes
                }))).json();
            }
            catch(exception) {
                exceptions.push(exception);
            }
        }
        window.failures ? window.failures.push(...exceptions) : window.failures = exceptions;
        throw new Error('Too many failed trials. For more information, check out window.failures.');
    }

    const urls = {
        list: '/note/full/page/?ts=:time:&limit=200',
        listWithSyncTag: '/note/full/page/?ts=:time:&limit=200&syncTag=:syncTag:',
        note: '/note/note/:id:/?ts=:time:',
        image: '/file/full?type=note_img&fileid=:id:'
    };
    const maxAttempts = 20;
    let folders = [];
    let notes = [];
    let images = [];
    let syncTag;
    let neededToContinue = true;

    console.log('Query start.');
    console.groupCollapsed('Notes fetched');
    do {
        const { data } = await query(syncTag ? 'listWithSyncTag' : 'list', { syncTag });
        if(data.folders) folders.push(...data.folders);
        console.log(folders.length, ' table(s) found:');
        console.log(folders.forEach(({ subject }) => subject));
        for(let { id } of data.entries) {
            const { data: { entry: noteData } } = await query('note', { id });
            //Request the referenced images simultaneously.
            for(let line of noteData.content.replace(/\<0\/\>\<.*?\/\>/g, '').split('\n'))
                if (line.startsWith('☺ ')) images.push({
                    id: line.substr(2),
                    image: await fetchImage(line.substr(2))
                });
            notes.push(noteData);
            console.count('note');
            console.log('Retrieved note:', noteData?.snippet?.substr?.(0, 20));
        }
        neededToContinue = data.entries.length;
        syncTag = data.syncTag;
    } while(neededToContinue); //the variable `data` can't be references here. Damn it!

    console.groupEnd('Notes fetched');
    window.exportedData = {
        folders,
        notes,
        images
    };
    console.log('Congrats! Check out window.exportedData.');
})();