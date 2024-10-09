<cfscript>
    workdate = createDate(2024,Month(now()), day(now()));

    todaymonth = dateFormat(now(),"mmm");
    todayFile = "datefiles/TODAY." & ucase(todaymonth);

    todayBirthdays = arrayNew();
    todayEvents = arrayNew();

    fileObject = fileOpen(todayFile);

    try
    {
        while (NOT fileIsEOF(fileObject))
        {
            myLine = fileReadLine(fileObject);
            myType = mid(myLine,1,1);
            myMonth = mid(myLine,2,2);
            myDay = mid(myLine,4,2);
            myYear = mid(myLine,6,4);
            myEvent = mid(myLine,11,100);
            myCompareDate = createDate(2024,myMonth, myDay);
            if (isNumeric(myYear))
            {
                myDate = createDate(myYear,myMonth, myDay);
            }
            else
            {
                myDate = createDate(2024,myMonth, myDay);
            }
            myPayload = {};
            myPayload.type = myType;
            myPayload.date = myDate;
            myPayload.event = myEvent;

            if (myCompareDate EQ workdate)
            {
                if (myType EQ "B")
                {
                    arrayAppend(todayBirthdays,myPayload);
                }
                if (myType EQ "S")
                {
                    arrayAppend(todayEvents,myPayload);
                }
            }

        }
    }
    catch (any err)
    {
        writeDump(err);
    }
    finally
    {
        fileClose(fileObject);
    }


</cfscript>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>What Happened Today?</title>
</head>
<body>

<h2>The Notible things for the day of : <cfoutput>#dateFormat(now(),"medium")#</cfoutput></h2>
<hr>

    <h3>Birthdays:</h3>
    <table border="1">
        <cfloop array="#todayBirthdays#" index="x">
        <tr>
            <td><cfif year(x.date) EQ year(now())><cfoutput>#dateFormat(x.date, "mmmm d")#</cfoutput><cfelse><cfoutput>#dateFormat(x.date, "long")#</cfoutput></cfif></td>
            <td><cfoutput>#x.event#</cfoutput></td>
        </tr>
        </cfloop>
    </table>

    <h3>Events:</h3>
    <table border="1">
        <cfloop array="#todayEvents#" index="x">
            <tr>
                <td><cfif year(x.date) EQ year(now())><cfoutput>#dateFormat(x.date, "mmmm d")#</cfoutput><cfelse><cfoutput>#dateFormat(x.date, "long")#</cfoutput></cfif></td>
                <td><cfoutput>#x.event#</cfoutput></td>
            </tr>
        </cfloop>
    </table>

</body>
</html>
