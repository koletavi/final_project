# final_project

This is the final project repository of Avishai Kolet & Amit Galkin

Subject: Design , Synthesis & P&R of Configurable systolic array processing elemet.

Project discription: In this project we studied systloic array architectures, specifically Weight stationary & Output stationary.
We then created a version of each processing elelemt (ws.v & os.v) and then a naive implementation of a configurable processing element (ncpe.v) using both modules.
To achive our goal we designed an alternative configurable processing element that uses only one multiplier and one adder.
In order to implement our design we created parmetrable multiplier (cmult.v) & adder (cadd.v) and used them to create version of the processing element (cpe.v)

After We synthesised and P&Red both modules we achived a reduction in area of about 30% in our improved version reletive to the naive version

We tried implamenting a general Systolic array but found our selves  with a few problems during verification that have yet to be solved, We've added the code of a single line
for further development when the time permits, We didn't add any technology releted files due to our limited licence use during academic studies 
