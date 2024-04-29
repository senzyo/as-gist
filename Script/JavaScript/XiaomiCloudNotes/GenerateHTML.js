//Convert to single HTML file.
//Reference: http://www.manongjc.com/detail/51-ccdsfcjzubummse.html
{
    const { folders, images, notes } = window.exportedData;
    let html = `<head>
    <meta name="viewport" content="width=device-width" />
    <title>小米笔记导出</title>
    <style> img { max-width: 90vw; max-height: 500px; } figcaption { color: rgb(0, 0, 0, .54); margin-top: 8px; }</style>
</head>
<h1>小米笔记导出</h1>
`;

    /**
     * Converts a time-stamp to a a Chinese date text.
     * @param time Time-stamp (Unit: ms) 
     */
    function formatDate(time) {
        const date = new Date(time);
        return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}.${date.getMilliseconds()}`;
    }

    const imageTable = images.reduce((reduced, { id, image }) => ({
        ...reduced,
        [id]: image
    }), {});
    notes.sort(({ modifyDate }, { modifyDate: _modifyDate }) => modifyDate - _modifyDate);

    for(let { content, extraInfo, folderId, id, createDate, modifyDate } of notes) {
        const folder = folders.filter(({ _id }) => _id === folderId)[0]?.subject ?? '未分类';
        let title, mindMap;
        if(extraInfo) {
            let { title: _title, note_content_type } = JSON.parse(extraInfo);
            title = _title ?? ' (无标题) ';
            mindMap = note_content_type === 'mind';
        } else {
            title = ' (无标题) ';
            mindMap = false;
        }
        html += [
            '<hr />',
            '<hr />',
            `<h2 id="${id}">${title}</h2>`,
            [
                `分类: ${folder}`,
                `创建: ${formatDate(createDate)}`,
                `最后修改: ${formatDate(modifyDate)}`,
            ].join(' | '),
            '<hr />',
            mindMap ? ' (暂不支持思维导图导出) ' : '',
            ...content.split('\n').map(line => {
                if(line.startsWith('☺ ')) return `<figure><img src="${
                    imageTable[line.replace(/\<0\/\>\<.*?\/\>/g, '').substr(2)]
                }" /><figcaption>${line.match(/\<0\/\>\<(?<title>.*?)\/\>/)?.groups.title.replaceAll('"', '&quot;') ?? ''}</figcaption></figure>`;
                return `<p>${line}</p>`;
            })
        ].join('\n');
    }

    const a = document.createElement('a');
    const blob = new Blob([ html ]);
    a.download = 'notes.html';
    a.href = URL.createObjectURL(blob);
    a.click();
    URL.revokeObjectURL(blob);
}